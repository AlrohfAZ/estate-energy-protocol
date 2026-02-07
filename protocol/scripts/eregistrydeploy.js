// deploy.js in your Hardhat project root
const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const ESTATE_NAME = "OPIC Estate";
    const STABLE_COIN = ethers.ZeroAddress;
    const TREASURY = ethers.Wallet.createRandom().address;
    const ACTIVE = 0;
    const EstateRegistry = await ethers.getContractFactory("EstateRegistry");
    const estateRegistry = await EstateRegistry.deploy(deployer.address, ESTATE_NAME, STABLE_COIN, TREASURY, ACTIVE);
    await estateRegistry.waitForDeployment();

    console.log("EstateRegistry deployed to:", estateRegistry.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

// Deployment address: 0x5FbDB2315678afecb367f032d93F642f64180aa3
