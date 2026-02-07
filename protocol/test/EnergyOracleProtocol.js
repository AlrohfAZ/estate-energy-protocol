const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("EnergyOracleProtocol", function () {
    let EstateRegistry;
    let estateRegistry;
    let admin;
    let user1;
    let user2;
    let EnergyOracleProtocol;
    let energyOracleProtocol;
    let oracle;

    const ESTATE_NAME = "OPIC Estate";
    const STABLE_COIN = ethers.ZeroAddress;
    const TREASURY = ethers.Wallet.createRandom().address;

    const ACTIVE = 0;

    beforeEach(async function () {
        [admin, user1, user2] = await ethers.getSigners();

        EstateRegistry = await ethers.getContractFactory("EstateRegistry");

        estateRegistry = await EstateRegistry.deploy(admin.address, ESTATE_NAME, STABLE_COIN, TREASURY, ACTIVE);

        await estateRegistry.waitForDeployment();
    });

    beforeEach(async function () {
        oracle = await ethers.getSigners();

        EnergyOracleProtocol = await ethers.getContractFactory("EnergyOracleProtocol");

        energyOracleProtocol = await EnergyOracleProtocol.deploy(estateRegistry);
    });

    describe("House Approval", function () {
        it("Admin can approve houses", async function () {
            await estateRegistry.approveHouses(user1.address, 3);
            expect (await estateRegistry.isApproved(user1.address)).to.equal(true);
            expect(await estateRegistry.isProducer(user1.address)).to.equal(true);
        });
    });

    describe("Submitting Claim", function () {
        it("Should allow producers submit claim", async function () {
            await expect (energyOracleProtocol.connect(user1).submitClaim())
        });
    });

    describe("Validate Claim", function () {
        it("Should allow only Oracle validate claim", async function() {
            await expect(energyOracleProtocol.connect(oracle).validation(user1));
        });
    });

    // This is temporary, function will be upgraded upon completion of token contract
    describe("Approving Mint", function () {
        it("Should allow only Oracle approve mint", async function() {
            await expect(energyOracleProtocol.connect(oracle).approveMint(user1));
        });
    });

    describe("Validate Claim", function () {
        it("Should allow only Oracle validate claim", async function() {
            await expect(energyOracleProtocol.connect(user2).validation(user1)).to.be.revertedWith("you are not the oracle");
        });
    });

    describe("Reseting Cycle", function () {
        it("Should allow only Oracle reset cycle", async function() {
            await expect(energyOracleProtocol.connect(oracle).resetCycle());
        });
    });
});