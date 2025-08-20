Multi-Sig Vault Smart Contract

A secure **multi-signature vault** built on the Stacks blockchain.  
The `multi-sig-vault` smart contract allows multiple parties to jointly manage STX funds, requiring a predefined quorum of approvals before executing sensitive actions such as withdrawals.

---

Features
- **Multi-Signature Control** – Requires multiple owners to approve withdrawals.
- **Customizable Quorum** – Define the minimum number of approvals needed.
- **Secure STX Storage** – Deposit and store funds safely in the vault.
- **Approval Workflow** – Owners must approve before funds can be released.
- **Transparency** – On-chain records of approvals and balances.

---

Contract Functions

Public Functions
- `create-vault (owners quorum)`  
  Initialize a new vault with defined owners and quorum.

- `deposit`  
  Deposit STX into the vault.

- `propose-withdrawal (recipient amount)`  
  Create a withdrawal proposal requiring approvals.

- `approve-withdrawal (proposal-id)`  
  Approve a pending withdrawal.

- `execute-withdrawal (proposal-id)`  
  Execute a withdrawal once the quorum of approvals is reached.

Read-Only Functions
- `get-balance` – Returns the vault’s STX balance.  
- `get-owners` – Lists the vault owners.  
- `get-approvals (proposal-id)` – Checks approvals for a proposal.  
- `get-quorum` – Returns the required number of approvals.

---

Deployment

Requirements
- [Stacks Blockchain](https://www.stacks.co)  
- [Clarinet](https://github.com/hirosystems/clarinet) (for local testing)  

Steps
1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/multi-sig-vault.git
   cd multi-sig-vault
Example Workflow

-Alice, Bob, and Carol create a vault requiring 2-of-3 signatures.
-Alice deposits 500 STX into the vault.
-Bob proposes a withdrawal of 200 STX to Carol.
-Alice approves the withdrawal.
-Quorum (2 approvals) is met → Funds are released to Carol.

Use Cases
-DAOs & Communities – Shared treasury management.
-Organizations – Secure fund custody requiring multiple signers.
-Escrow & Custody – Trustless holding of assets until consensus.

License
This project is licensed under the MIT License.
