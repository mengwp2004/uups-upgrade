const { ethers, upgrades } = require("hardhat");

const token = "0xe11a86849d99f524cac3e7a0ec1241828e332c62";
const maxClaimBalance = 100;
const maxClaimInterval = 60;

async function main() {
  const CapitalDepot = await ethers.getContractFactory("CapitalDepot");

  console.log("Deploying CapitalDepot...");

  const apitalDepot = await upgrades.deployProxy(CapitalDepot, [token,maxClaimBalance,maxClaimInterval], {
    initializer: "initialize",
  });
  await apitalDepot.deployed();

  console.log("CapitalDepot deployed to:", apitalDepot.address);
}

main();
