
# EduCred – Academic Certificate Verifier

EduCred is a decentralized application (DApp) that combats academic credential fraud by enabling institutions to issue and verify certificates on the blockchain. It empowers students to securely store their academic records and allows third parties to independently confirm their authenticity.

---

## Problem Statement

The prevalence of fake degrees and unverifiable transcripts has undermined the credibility of educational achievements globally. Traditional verification methods are often manual, time-consuming, and insecure. EduCred addresses these issues by leveraging blockchain technology to:

* Issue tamper-proof academic certificates
* Enable real-time on-chain verification of academic records
* Protect access using decentralized identity management tied to wallet addresses

---

## Features

* **Student Registration**: Each student is registered using a verified ID linked to their wallet address.
* **Certificate Issuance**: Institutions can issue hashed certificates stored immutably on-chain.
* **Certificate Verification**: Employers and institutions can publicly verify the authenticity of certificates.
* **Secure Access**: Only authorized users can view or manage their credentials, protected by wallet-based access.
* **Audit Trail**: Issuance logs include timestamps and institutional metadata for transparency and traceability.

---

## Smart Contract Functions

| Function             | Description                                                        |
| -------------------- | ------------------------------------------------------------------ |
| `register-student`   | Registers a student by mapping their wallet to a student ID        |
| `issue-certificate`  | Allows institutions to create a hashed certificate record on-chain |
| `verify-certificate` | Checks the authenticity of a certificate by certificate ID         |
| `get-student-id`     | Retrieves the registered ID associated with a wallet               |

Each certificate issued is immutable, time-stamped, and easily verifiable by any party with access to the public ledger.

---

## Installation and Testing

### Prerequisites

* Clarinet (Stacks blockchain development CLI)
* Node.js (optional, for UI integration)

### Setup Instructions

```bash
# Clone the project
git clone https://github.com/your-username/educred-dapp.git
cd educred-dapp

# Check for errors
clarinet check

# Run contract tests
clarinet test
```

---

## Repository Structure

```
contracts/
  └── educred.clar           # Smart contract logic

tests/
  └── educred_test.ts        # Test suite for contract behavior

README.md                    # Project documentation
```

---

## License

This project is licensed under the MIT License. You are free to use, modify, and distribute it under the terms of the license.

