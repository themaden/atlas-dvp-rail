
# Atlas DVP Rail

Atlas DVP Rail is a modular smart contract system for atomic Delivery vs Payment (DVP) settlement across Layer 2 (L2) blockchains. It is designed for secure, proof-based asset transfers and registry management, using Foundry for development and testing.

## Features

- **Receipt1155**: ERC-1155 token contract for representing receipts and multi-asset settlements.
- **SettlementRegistry**: Registry contract for managing ownership and settlement logic.
- **Spoke**: L2 contract for locking and releasing assets based on proof verification.
- **ProofAdapterMock**: Mock proof verifier for testing cross-chain proofs.
- **MockERC20**: Test ERC-20 token for simulating asset transfers.

## Project Structure

- `src/` — Main smart contracts
	- `Receipt1155.sol`, `SettlementRegistry.sol`, `l2/Spoke.sol`, `l2/ProofAdapterMock.sol`, `mock/MockERC20.sol`
- `test/` — Foundry test files
- `script/` — Deployment and scripting utilities
- `lib/` — External libraries (e.g., forge-std)

## Development

This project uses [Foundry](https://book.getfoundry.sh/) for Solidity development.

### Build Contracts

```bash
forge build
```

### Run Tests

```bash
forge test
```

### Local Node

Start a local Ethereum node for testing:

```bash
anvil
```

### Format Code

```bash
forge fmt
```

### Gas Snapshots

```bash
forge snapshot
```

## Deployment

Example deployment script:

```bash
forge script script/Deploy.s.sol --rpc-url <your_rpc_url> --private-key <your_private_key>
```

## License

MIT
