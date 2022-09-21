const { ethers, upgrades } = require("hardhat");

const PROXY = "0x297b47b873520A35224B3c029e36AcC23d19Aa42";

async function main() {
  const CapitalDepotV3 = await ethers.getContractFactory("CapitalDepotV3");
  console.log("Upgrading CapitalDepotV3...");
  await upgrades.upgradeProxy(PROXY, CapitalDepotV3);
  console.log("CapitalDepot upgraded successfully");
}

main();
