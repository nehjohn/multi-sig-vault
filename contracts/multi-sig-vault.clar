(define-constant quorum u2)

(define-data-var contract-owner principal tx-sender)
(define-data-var signers (list 10 principal) (list tx-sender))

(define-map proposals
  { proposal-id: uint }
  {
    proposer: principal,
    recipient: principal,
    amount: uint,
    approvals: uint,
    executed: bool
  })

(define-map votes
  { proposal-id: uint, signer: principal }
  { approved: bool })

(define-data-var proposal-counter uint u0)

;; Add a signer (only contract deployer/owner)
(define-public (add-signer (signer principal))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) (err u100))
        (var-set signers (unwrap! (as-max-len? (append (var-get signers) signer) u10) (err u107)))
        (ok signer))
)

;; Create a new withdrawal proposal
(define-public (create-proposal (recipient principal) (amount uint))
  (let ((proposal-id (var-get proposal-counter)))
    (begin
      (map-set proposals 
              { proposal-id: proposal-id }
              {
                proposer: tx-sender,
                recipient: recipient,
                amount: amount,
                approvals: u0,
                executed: false
              })
      (var-set proposal-counter (+ proposal-id u1))
      (ok proposal-id)
    )))

;; Approve a proposal
(define-public (approve-proposal (proposal-id uint))
  (let ((proposal (unwrap! (map-get? proposals { proposal-id: proposal-id }) (err u101))))
    (begin
      ;; Ensure signer is authorized
      (asserts! (is-some (index-of? (var-get signers) tx-sender)) (err u102))
      ;; Prevent duplicate approvals
      (asserts! (not (is-some (map-get? votes { proposal-id: proposal-id, signer: tx-sender }))) (err u103))
      ;; Increment approval count
      (map-set votes { proposal-id: proposal-id, signer: tx-sender } { approved: true })
      (map-set proposals { proposal-id: proposal-id }
        (merge proposal { approvals: (+ (get approvals proposal) u1) }))
      (ok "Approved")
    )))

;; Execute proposal if quorum is met
(define-public (execute-proposal (proposal-id uint))
  (let ((proposal (unwrap! (map-get? proposals { proposal-id: proposal-id }) (err u104))))
    (begin
      (asserts! (>= (get approvals proposal) quorum) (err u105))
      (asserts! (not (get executed proposal)) (err u106))

      (try! (stx-transfer? (get amount proposal) (as-contract tx-sender) (get recipient proposal)))

      (map-set proposals { proposal-id: proposal-id }
        (merge proposal { executed: true }))

      (ok "Proposal executed")
    )))

;; Read-only: Get proposal details
(define-read-only (get-proposal (proposal-id uint))
  (ok (map-get? proposals { proposal-id: proposal-id })))
