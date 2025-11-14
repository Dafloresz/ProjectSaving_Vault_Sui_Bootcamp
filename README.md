# Savings Vault – A Time-Locked Digital Piggy Bank on Sui

> **Smart Contract Module:** `savings_vault::vault`  
> **Language:** Move (Sui Blockchain)  
> **Purpose:** Create a secure, time-locked savings vault where users can deposit **SUI** tokens and **only withdraw after a specific epoch**.

---
## Overview

This smart contract implements a **digital piggy bank** on the **Sui blockchain**.  
Users can:

1. **Create a vault** with a future unlock epoch.
2. **Deposit SUI** into their vault anytime.
3. **Withdraw all funds** — **only after** the specified epoch has passed.

It’s perfect for **commitment savings**, **goal-based saving**, or **enforced delayed gratification**.

## Key Features

| Feature | Description |
|--------|-----------|
| **Time-Locked Withdrawal** | Funds are locked until a chosen `unlock_epoch` |
| **Owner-Only Access** | Only the vault owner can deposit or withdraw |
| **Event Tracking** | Deposits and withdrawals emit on-chain events |
| **Zero Balance Start** | Vault starts empty; grows with deposits |
| **Full Withdrawal** | Withdraws entire balance when unlocked |

## Smart Contract Structure
### `Vault` Struct
``move
public struct Vault has key, store {
    id: UID,
    owner: address,
    balance: Balance<SUI>,
    unlock_epoch: u64,
}

id: Unique object ID
owner: Who controls the vault
balance: Stored SUI tokens
unlock_epoch: Epoch when withdrawal is allowed


## Core Functions
1. create_vault(unlock_epoch: u64)
Creates a new vault and transfers ownership to the caller.
movepublic entry fun create_vault(unlock_epoch: u64, ctx: &mut TxContext)

Example:
movecreate_vault(1000, ctx); // Unlock at epoch 1000
Create Vault Example
Illustration: User creates vault locked until epoch 1000

3. deposit(vault: &mut Vault, payment: Coin<SUI>)
Deposits SUI into the vault. Only the owner can deposit.
movepublic entry fun deposit(vault: &mut Vault, payment: Coin<SUI>, ctx: &mut TxContext)
Example:
movedeposit(my_vault, coin_of_500_SUI, ctx);
Deposit Flow
User deposits 500 SUI into their locked vault
Emits: Deposited event

4. withdraw(vault: &mut Vault)
Withdraws all funds from the vault only if current epoch ≥ unlock_epoch.
movepublic entry fun withdraw(vault: &mut Vault, ctx: &mut TxContext)
Requirements:

Caller must be owner
Current epoch must be ≥ unlock_epoch

Example:
move// Only works if tx_context::epoch(ctx) >= 1000
withdraw(my_vault, ctx);
Withdrawal Success
Funds released after epoch 1000
Emits: Withdrawn event

4. get_balance(vault: &Vault): u64
Read function to check current balance.
movepublic fun get_balance(vault: &Vault): u64
Useful for frontends and explorers.

Events
Deposited
movepublic struct Deposited has copy, drop {
    vault_id: ID,
    amount: u64,
    owner: address,
    epoch: u64,
}
Withdrawn
movepublic struct Withdrawn has copy, drop {
    vault_id: ID,
    amount: u64,
    owner: address,
    epoch: u64,
}
These events allow dApps to track savings activity in real time.

## Use Cases

Use Case,How It Works
New Year Savings,Lock funds until Jan 1st (epoch X)
Wedding Fund,"Save for 6 months, unlock on wedding epoch"
Habit Building,No-spend challenge with enforced lock
Child Savings,Parent locks allowance until maturity


## Security & Design Notes

Feature,Why It Matters
assert!(sender == vault.owner),Prevents unauthorized access
assert!(current_epoch >= unlock_epoch),Enforces time lock
"balance::split(..., amount)",Safely extracts full balance
Coin<SUI> input,Standard Sui coin handling
Events,Full transparency & indexing


How to Interact (Example Script)

use savings_vault::vault;

// Step 1: Create vault (lock for 100 epochs)
vault::create_vault(150, ctx);

// Step 2: Deposit 1000 SUI
let coin = coin::mint(1000, ctx);
vault::deposit(&mut my_vault, coin, ctx);

// Step 3: Later... after epoch 150
vault::withdraw(&mut my_vault, ctx); // Succeeds!

Testing & Deployment

Compile & Test Locally
sui move test

Publish to Devnet/Testnet
sui client publish --gas-budget 100000000


##Project Files
savings_vault/
├── sources/
│   └── vault.move
├── tests/
│   └── vault_tests.move
└── Move.toml

Contributing
Feel free to:

Add partial withdrawals
Support multiple coins
Add interest simulation
Build a frontend dashboard


License
MIT © 2025

Start saving with discipline — on-chain.
Piggy Bank Locked
“The best time to save was yesterday. The next best time is now — with a time lock.”

GitHub Repo: https://github.com/Dafloresz/ProjectSaving_Vault_Sui_Bootcamp
Explorer: Suiscan
Docs: Sui Move Book

Made with ❤️ on Sui
