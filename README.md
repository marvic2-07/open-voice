# Open Voice Smart Contract

This repository contains the Clarity smart contract for **Open Voice**, a decentralized complaint management system built on the Stacks blockchain.

## Features

- **Admin Management:**  
  - Add or remove admins (only existing admins can manage).
  - Initial contract deployer is set as admin.

- **Complaint Submission:**  
  - Users can submit complaints with department and message.
  - Each complaint receives a unique ID.

- **Complaint Status Update:**  
  - Only admins can update the status of complaints.

- **Complaint Query:**  
  - Anyone can view complaints by ID.
  - Get the total number of complaints.

## Contract Structure

- **Maps:**  
  - `complaints`: Stores complaint details by ID.
  - `admins`: Tracks admin principals.

- **Functions:**  
  - `add-admin`: Add a new admin.
  - `remove-admin`: Remove an admin.
  - `submit-complaint`: Submit a new complaint.
  - `update-status`: Update complaint status (admin only).
  - `get-complaint`: View complaint details.
  - `get-total-complaints`: Get total complaints count.

## Usage

1. **Deploy the contract** on the Stacks blockchain.
2. **Interact** using Clarity functions via your preferred Stacks wallet or CLI.

## File Structure

- `contracts/open-voice.clar`: Main smart contract source code.
- `.gitignore`: Excludes logs, cache, coverage, and settings files from version control.
