# docs/setup-guide.md
# Pyth Network Entropy Setup Guide

## Quick Start

```bash
git clone https://github.com/vvdinqrs-blip/eve-v1.git
cd eve-v1
npm install hardhat @pythnetwork/entropy-sdk-solidity
node scripts/deploy.js
```

## Prerequisites

- Node.js v14+
- Hardhat CLI
- Pyth entropy contract address

## Configuration

1. Update `config/pyth_config.py` with entropy contract address
2. Configure network in `hardhat.config.js`
3. Set up wallet credentials in `.env`

## Deployment

```bash
npm install
npx hardhat compile
node scripts/deploy.js
```

## Testing

```bash
npm test
python python/test_entropy.py
```

## Resources

- [Pyth Network Docs](https://docs.pyth.network/entropy/generate-random-numbers-evm)
- [Debug Callback Failures](https://docs.pyth.network/entropy/debug-callback-failures)

---

**Created by**: vvdinqrs-blip
