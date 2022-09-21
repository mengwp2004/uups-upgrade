const { ethers, upgrades } = require("hardhat");

const PROXY = "0x297b47b873520A35224B3c029e36AcC23d19Aa42";

async function main() {
  const CapitalDepotV2 = await ethers.getContractFactory("CapitalDepotV2");
  console.log("Upgrading CapitalDepot...");
  await upgrades.upgradeProxy(PROXY, CapitalDepotV2);
  console.log("CapitalDepot upgraded successfully");
}

main();
