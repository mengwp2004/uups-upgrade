# UUPS Proxy Pattern

## Setup:

- Clone the repo

- Install the dependencies
  `npm install`

- Create a new file `.env` from `.env.example`

```sh
cp .env .env.example
```

- In `.env` file add `INFURA_API_KEY`, `PRIVATE_KEY` and `ETHERSCAN_API_KEY`

PRIVATE_KEY =  'xxx' // private key

ETHERSCAN_API_KEY = 'xxx' // eth scan api key

INFURA_API_KEY= '' 

ALCHEMY_API_KEY= "xxx"  // alchemy api key

> Note: This project uses Hardhat

## Compiling:

- To compile the contracts

```sh
npm run compile
```

## Testing:

- To run the unit tests, use the command.

```sh
npm run tests
```

## Deployment and Upgrades:

- To deploy the v1 contract to kovan run :

goerli is ethereum pos test net.

```sh
npx hardhat run ./scripts/deploy_pizza_v1.js --network goerli
```

- To upgrade to V2, run :

```sh
npx hardhat run ./scripts/upgrade_pizza_v2.js --network goerli
```

- To upgrade to V3, add new storage run :

```sh
npx hardhat run ./scripts/upgrade_pizza_v3.js --network goerli
```

- To upgrade to V4, modif storage ,will conflict run :

```sh
npx hardhat run ./scripts/upgrade_pizza_v4.js --network goerli
```

> Note: More networks can be configured in the `hardhat.config.js` file.

## Verification:

To verify the contracts on Etherscan

```sh
npx hardhat verify --network kovan <DEPLOYED_CONTRACT_ADDRESS>
```
