# Pyth Network Entropy Implementation for Dice Bot

## Overview

This repository implements verifiable randomness using **Pyth Network Entropy** from https://docs.pyth.network/entropy/generate-random-numbers-evm for the telegram-dice-bot project.

## Features

- Solidity Smart Contract (On-chain) with IEntropyConsumer interface
- Python Off-Chain Implementation  
- Generate random numbers in any range using mapRandomNumber
- Callback mechanism for secure randomness delivery
- Multiple attributes generation per transaction

## Quick Start

### Prerequisites
- Solidity compiler (^0.8.0)
- Hardhat or Truffle framework
- Web3.js / Ethers.js
- Pyth Network entropy contract address

## Project Structure

```
eve-v1/
├── README.md
├── contracts/
│   ├── DiceBot.sol
│   └── EntropyHelper.sol
├── scripts/
│   ├── deploy.js
│   └── requestEntropy.js
├── python/
│   ├── entropy_consumer.py
│   └── test_entropy.py
├── config/
│   └── pyth_config.py
└── docs/
    └── setup-guide.md
```

## Implementation Details

### 1. Solidity Smart Contract

```solidity
pragma solidity ^0.8.0;

import { IEntropyConsumer } from "@pythnetwork/entropy-sdk-solidity/IEntropyConsumer.sol";
import { IEntropyV2 } from "@pythnetwork/entropy-sdk-solidity/IEntropyV2.sol";

contract TelegramDiceBot is IEntropyConsumer {
    IEntropyV2 entropy;
    mapping(address => DiceState) public diceStates;
    
    constructor(address entropyAddress) payable {
        owner = msg.sender;
        entropy = IEntropyV2(entropyAddress);
    }

    function requestRandomNumber() external payable returns (uint64) {
        uint256 fee = entropy.getFeeV2();
        return entropy.requestV2{ value: fee }();
    }

    function entropyCallback(
        uint64 sequenceNumber,
        address provider,
        bytes32 randomNumber
    ) internal override {
        DiceState state = diceStates[address(msg.sender)];
        int256 roll = mapRandomNumber(randomNumber, 1, 6);
        state.lastRoll = roll;
    }

    function getEntropy() internal view override returns (address) {
        return address(entropy);
    }
}
```

### 2. Random Number Mapping

```solidity
function mapRandomNumber(
    bytes32 randomNumber,
    int256 minRange,
    int256 maxRange
) internal pure returns (int256) {
    require(minRange <= maxRange, "Invalid range");
    uint256 range = uint256(maxRange - minRange + 1);
    uint256 randomUint = uint256(randomNumber);
    return minRange + int256(randomUint % range);
}
```

### 3. Generate Multiple Attributes

```solidity
function generateDiceAttributes(bytes32 randomNumber) internal {
    // Standard dice roll (1-6)
    int256 roll = mapRandomNumber(randomNumber, 1, 6);
    
    // Bonus (0-100)
    int256 bonus = mapRandomNumber(
        keccak256(abi.encodePacked(randomNumber, "bonus")),
        0, 100
    );
}
```

## Configuration

### Pyth Network Contract Addresses
- **Polygon**: Check Pyth docs for entropy contract address
- **Ethereum**, **Arbitrum**: Available via Pyth documentation

Update in `config/pyth_config.py`:

```python
PYTH_CONFIG = {
    "entropy_contract_address": "0x...",
    "chain_id": "polygon",
    "callback_timeout": 30,
}
```

## Python Implementation (Off-Chain)

```python
class EntropyDiceConsumer:
    def __init__(self, provider_address):
        self.provider_address = Web3.to_checksum_address(provider_address)
        # Setup bot logic here
    
    def map_random_number(self, data: bytes, min_val: int, max_val: int) -> int:
        random_uint = int.from_bytes(data[:32], 'big')
        range_val = max_val - min_val + 1
        return min_val + (random_uint % range_val)
```

## Installation

### JavaScript (Solidity):
```bash
npm install --save-dev hardhat
npm install @pythnetwork/entropy-sdk-solidity
```

### Python:
```bash
pip install web3 eth-account python-telegram-bot
```

## Deployment Steps

1. Clone repository: `git clone https://github.com/vvdinqrs-blip/eve-v1.git`
2. Install dependencies: `npm install`
3. Configure entropy contract address
4. Deploy: `node scripts/deploy.js`
5. Test callbacks

## Important Notes

- **Callback must NOT return errors** - Pyth Network requires this
- Each entropy request costs gas/ETH/MATIC (~0.01-0.1 ETH)
- Polygon is typically cheaper than Ethereum mainnet

## Resources

- Main Docs: https://docs.pyth.network/entropy/generate-random-numbers-evm
- Debug Callbacks: https://docs.pyth.network/entropy/debug-callback-failures
- Pyth GitHub: https://github.com/pyth-network

---

**Implementation based on**: [Pyth Network Entropy](https://docs.pyth.network/entropy/generate-random-numbers-evm)
