# Digital Inheritance System

A blockchain-based digital inheritance system built on the Stacks network that enables secure and automated transfer of digital assets to designated beneficiaries.

## Features

- Create digital inheritance with specified beneficiary and deadline
- Proof of life mechanism to prevent premature claims
- Automated transfer of assets after deadline
- Update beneficiary functionality
- Secure and transparent inheritance management

## How it works

1. Asset owner creates an inheritance specifying:
   - Beneficiary address
   - Amount to inherit
   - Time period for proof of life
2. Owner must periodically prove they're alive
3. If owner fails to prove life for the specified period, beneficiary can claim inheritance
4. Assets are automatically transferred to beneficiary upon valid claim

## Security

- Only contract owner can create and modify inheritances
- Proof of life mechanism prevents unauthorized claims
- Time-locked transfers ensure security
- All transactions are recorded on the Stacks blockchain
