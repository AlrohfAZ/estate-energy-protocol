const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("EstateRegistry", function () {
  let EstateRegistry;
  let estateRegistry;
  let admin;
  let user1;
  let user2;

  const ESTATE_NAME = "GreenVille Estate";
  const STABLE_COIN = ethers.ZeroAddress;
  const TREASURY = ethers.Wallet.createRandom().address;

  // Enum value for ProtocolState.Active
  const ACTIVE = 0;

  beforeEach(async function () {
    // Get test accounts
    [admin, user1, user2] = await ethers.getSigners();

    // Get contract factory
    EstateRegistry = await ethers.getContractFactory("EstateRegistry");

    // Deploy contract
    estateRegistry = await EstateRegistry.deploy(
      admin.address,
      ESTATE_NAME,
      STABLE_COIN,
      TREASURY,
      ACTIVE
    );

    await estateRegistry.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should set the correct admin", async function () {
      expect(await estateRegistry.admin()).to.equal(admin.address);
    });

    it("Should set the correct estate name", async function () {
      expect(await estateRegistry.estateName()).to.equal(ESTATE_NAME);
    });

    it("Should start in Active state", async function () {
      expect(await estateRegistry.protocolState()).to.equal(ACTIVE);
    });
  });

  describe("House approval", function () {
    it("Admin can approve a house", async function () {
      await estateRegistry.approveHouses(user1.address, 3); // Role.Both = 3

      // No direct getter, but success = no revert
      expect(true).to.be.true;
    });

    it("Should emit HouseApproved event", async function () {
      await expect(
        estateRegistry.approveHouses(user1.address, 1) // Role.Producer
      )
        .to.emit(estateRegistry, "HouseApproved")
        .withArgs(user1.address, 1);
    });

    it("Non-admin cannot approve a house", async function () {
      await expect(
        estateRegistry.connect(user1).approveHouses(user2.address, 2)
      ).to.be.revertedWith("Not the admin");
    });
  });

  describe("House revocation", function () {
    beforeEach(async function () {
      await estateRegistry.approveHouses(user1.address, 3);
    });

    it("Admin can revoke a house", async function () {
      await estateRegistry.revokeHouses(user1.address);
      expect(true).to.be.true;
    });

    it("Should emit HouseRevoked event", async function () {
      await expect(
        estateRegistry.revokeHouses(user1.address)
      )
        .to.emit(estateRegistry, "HouseRevoked")
        .withArgs(user1.address);
    });

    it("Non-admin cannot revoke a house", async function () {
      await expect(
        estateRegistry.connect(user1).revokeHouses(user1.address)
      ).to.be.revertedWith("Not the admin");
    });
  });

  describe("Tariff and Mint Cap", function () {
    it("Admin can set daily tariff", async function () {
      await estateRegistry.setTariff(100);
      expect(await estateRegistry.dailyTariff()).to.equal(100);
    });

    it("Admin can set mint cap", async function () {
      await estateRegistry.setMintCap(1000);
      expect(await estateRegistry.dailyMintcap()).to.equal(1000);
    });

    it("Non-admin cannot set tariff", async function () {
      await expect(
        estateRegistry.connect(user1).setTariff(50)
      ).to.be.revertedWith("Not the admin");
    });
  });

  describe("Oracle management", function () {
    it("Admin can set oracle", async function () {
      await estateRegistry.setOracle(user1.address);
      expect(await estateRegistry.oracle()).to.equal(user1.address);
    });

    it("Non-admin cannot set oracle", async function () {
      await expect(
        estateRegistry.connect(user1).setOracle(user2.address)
      ).to.be.revertedWith("Not the admin");
    });
  });

  describe("Stablecoin getter", function () {
    it("Should return correct stablecoin address", async function () {
      expect(await estateRegistry.getstableCoin()).to.equal(STABLE_COIN);
    });
  });
});
