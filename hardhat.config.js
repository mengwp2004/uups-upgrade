require("@nomiclabs/hardhat-ethers");
require("@openzeppelin/hardhat-upgrades");
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-ethers");
require("dotenv").config();
require("@nomiclabs/hardhat-web3");


// task action function receives the Hardhat Runtime Environment as second argument
task("accounts", "Prints accounts", async (_, { web3 }) => {
  console.log(await web3.eth.getAccounts());
});

module.exports = {
  solidity: "0.8.10",
  networks: {
    kovan: {
      url: `https://kovan.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY],
    },
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${process.env.ALCHEMY_GOERLI_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY],
    },	  
    mumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${process.env.ALCHEMY_MATIC_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY],
    },	
    polygon: {
      url: `https://polygon-mainnet.g.alchemy.com/v2/${process.env.ALCHEMY_POLYGON_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY],
    },	  
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
    //apiKey: process.env.POLYGONSCAN_API_KEY,
  },
};
