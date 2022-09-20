const { ethers, upgrades } = require("hardhat");

const token = "0x12A3782f99506cfA6c1D9dd41AF481A5D1e18EA2";
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
