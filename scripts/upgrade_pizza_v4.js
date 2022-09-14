const { ethers, upgrades } = require("hardhat");

const PROXY = "0x4Bf2DE640B80FDe37Dc339D17696464044C588Fd";

async function main() {
  const PizzaV4 = await ethers.getContractFactory("PizzaV4");
  console.log("Upgrading Pizza...");
  await upgrades.upgradeProxy(PROXY, PizzaV4);
  console.log("Pizza upgraded successfully");
}

main();
