# Estate Energy Protocol Smart Contract

A v0.1 energy protocol built on **Ethereum**, using a single estate as its specimen, allows users to submit energy production claims, transfer EnergyTokens, convert EnergyTokens to UsageUnits, and consume UsageUnits. This contract is written in **Solidity** and compatible with **EVM-based blockchains**.

## Table of Contents

- [Contracts](#contracts)

## Contracts

- This protocol consists of 4 contracts:
- [EstateRegistry](#estateregistry)
- [EnergyOracleProtocol](#energyoracleprotocol)
- [kWhToken](#kwhtoken)
- [EnergyMarketplace](#energymarketplace)
- [UsageUnitVault](#usageunitvault)


## EstateRegistry

## Table of Contents

- [Description](#description)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Deployment](#deployment)
- [Usage](#usage)
- [Contract Details](#contract-details)
- [Testing](#testing)
- [License](#license)

## Description

This smart contract currently has 4 actors:

- ADMIN: The admin assigns roles to houses in the estate, there are 4 roles: Producer, Consumer, Both, and None.
- ORACLE: The oracle validates production claims and approves minting, while enforcing the dailyTariffLimit, and dailyCapLimit
- PRODUCER: The producer submits production claims for validation, is minted to, and transfers EnergyTokens.
- CONSUMER: The consumer buys EnergyTokens, and can convert them to UsageUnits for household usage.
