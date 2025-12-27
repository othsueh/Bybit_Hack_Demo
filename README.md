# Bybit Hack Simulation Demo (Sepolia)

> **Disclaimer**: This is a purely educational simulation demonstrating the mechanics of the Bybit hack incident. It is deployed and executed on the **Sepolia** testnet for research purposes only.

## Overview

This project simulates the specific attack vector used in the Bybit incident, involving:
1.  **Setup**: Deploying a victim MultiSig wallet and funding it with MockUSDT.
2.  **The Hack**: The attacker bypasses security (or uses a compromised key simulation) to transfer funds.
3.  **Laundering**: The stolen funds are moved to a MockTornado contract to simulate breaking the transaction graph.

## Workflow

The `Exploit.s.sol` script automates the entire process:
-   **Step 1: Setup**: Deploys `MockUSDT`, `SimpleMultiSig`, and `MockTornado`. Funds the wallet.
-   **Step 2: Attack**: Constructs a malicious payload and signature to execute a specialized transaction on the MultiSig wallet, draining funds to the Attacker.
-   **Step 3: Laundering**: The attacker deposits the stolen USDT into the `MockTornado` contract.

## Actual Execution

Below are the on-chain addresses for the simulation performed on Sepolia.

### Address Table

| Role / Contract | Address & Sepolia Scan Link | Description |
| :--- | :--- | :--- |
| **Attacker EOA** | [0x27b4435bD0D8b5F7C82b0792945E56c46a524AeD](https://sepolia.etherscan.io/address/0x27b4435bd0d8b5f7c82b0792945e56c46a524aed) | The account initiating the hack |
| **Victim (Deployer)** | [0xB2DB72B02959F33De75DcBA399D27261910D58e2](https://sepolia.etherscan.io/address/0xb2db72b02959f33de75dcba399d27261910d58e2) | The creator of the MultiSig wallet |
| **MockUSDT** | [0xA83d210655Eeb3F66E2708B0A4D9606fcA33Ca48](https://sepolia.etherscan.io/address/0xa83d210655eeb3f66e2708b0a4d9606fca33ca48) | The simulation token contract |
| **SimpleMultiSig** | [0x3A2De53a4E44A0BFB5Ea6D8ef8999CC8AB24c19F](https://sepolia.etherscan.io/address/0x3a2de53a4e44a0bfb5ea6d8ef8999cc8ab24c19f) | The victim wallet contract |
| **MockTornado** | [0xe38581b6B78b8176C815368713A4d209F320c6e9](https://sepolia.etherscan.io/address/0xe38581b6b78b8176c815368713a4d209f320c6e9) | The privacy pool (mixer) |

### Demo Video
[Demo Video](https://drive.google.com/file/d/1C2KNxbaNR9Vu8HhTeM5z42KiVuGBW_11/view?usp=sharing)

---

## Usage

To run this simulation locally or on a testnet:

### Prerequisites
- [Foundry](https://getfoundry.sh/) installed.

### Run Script
```shell
# Load environment variables
source .env

# Execute the Exploit script on Sepolia
forge script script/Exploit.s.sol:ExploitScript --rpc-url $RPC_URL --broadcast -vvvv
```

### Build & Test
```shell
forge build
forge test
```
