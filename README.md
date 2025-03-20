## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

# Upgradeable Smart Contract with Version Control

This repository contains a smart contract upgrade system with version control functionality implemented using the UUPS proxy pattern.

## Features

- **Version History**: Maintains a complete history of all implementation addresses that have been used
- **Upgrade Functionality**: Allows upgrading to new implementations while preserving state
- **Rollback Capability**: Supports rolling back to any previous implementation version
- **Secure Ownership**: Only the owner can perform upgrades and rollbacks
- **State Preservation**: All contract state is preserved across upgrades and rollbacks

## Contracts

### VersionControlUpgradeable.sol

The core contract that implements the version control functionality:

- Inherits from OpenZeppelin's UUPSUpgradeable and Ownable contracts
- Maintains an array of all implementation addresses
- Tracks the current active implementation
- Provides methods for upgrading and rolling back

### Implementation.sol

A sample implementation contract that demonstrates the basic functionality:

- Extends VersionControlUpgradeable
- Provides storage variables and functions that interact with them
- Demonstrates how to build on top of the version control system

### ImplementationV2.sol

An upgraded implementation contract that shows how to add new functionality:

- Extends the base Implementation
- Adds new state variables and functions
- Demonstrates how upgrades can introduce new features

## Tests

Comprehensive tests are included to verify the functionality:

- Initial state verification
- Upgrade process testing
- Rollback functionality validation
- Access control testing

## Scripts

Deployment and administration scripts:

- `Deploy.s.sol`: Deploys the initial implementation and proxy
- `Upgrade.s.sol`: Upgrades to a new implementation
- `Rollback.s.sol`: Rolls back to a previous implementation version

## Usage

### Environment Setup

Create a `.env` file with the following variables:

```
PRIVATE_KEY=your_private_key
PROXY_ADDRESS=deployed_proxy_address
VERSION_INDEX=index_to_rollback_to
```

### Deployment

```bash
# Deploy the initial implementation and proxy
forge script script/Deploy.s.sol --broadcast --rpc-url <your_rpc_url>
```

### Upgrade

```bash
# Upgrade to a new implementation
forge script script/Upgrade.s.sol --broadcast --rpc-url <your_rpc_url>
```

### Rollback

```bash
# Rollback to a previous implementation
forge script script/Rollback.s.sol --broadcast --rpc-url <your_rpc_url>
```

## Development

Built with [Foundry](https://github.com/foundry-rs/foundry) and [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts).

### Prerequisites

- Foundry installed
- OpenZeppelin contracts library

### Running Tests

```bash
forge test
```

## License

This project is licensed under the MIT License.
