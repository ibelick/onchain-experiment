import { ethers, waffle } from "hardhat";
import { Contract, BigNumber } from "ethers";
import assert from "assert";

const { expect } = require("chai");

const parseEther = (amount: string) => {
  return BigNumber.from(ethers.utils.parseEther(amount));
};

const MINT_FEE = parseEther("0.003");
const ether = 1e18;

describe("CollectibleOnChain", () => {
  let nftContract: Contract;
  let owner: any;
  let beneficiary: any;

  beforeEach(async () => {
    const nftContractFactory = await ethers.getContractFactory(
      "CollectibleOnChain"
    );
    const nftGenerator = await (
      await ethers.getContractFactory("CollectibleGenerator")
    ).deploy();
    [owner, beneficiary] = await ethers.getSigners();
    nftContract = await nftContractFactory.deploy(
      nftGenerator.address,
      MINT_FEE,
      10
    );
    await nftContract.deployed();
    assert(nftContract.address);
  });

  it("should have a price of 0.003 ether", async () => {
    const unitPrice = await nftContract.getUnitPrice();
    assert(unitPrice, (0.003 * ether).toString());
  });

  it("should fail to mint when sale is not started", async () => {
    const unitPrice = await nftContract.getUnitPrice();
    try {
      await nftContract.mint(1, { value: unitPrice });
    } catch (error) {
      assert(error);
    }
  });

  it("should fail set public mint active if no beneficiary", async () => {
    try {
      expect(await nftContract.publicMintActive()).to.equal(false);
      await nftContract.setPublicMintActive();
    } catch (error) {
      assert(error);
    }
  });

  it("should fail to mint a collectibe if no beneficiary", async () => {
    const unitPrice = await nftContract.getUnitPrice();
    try {
      await nftContract.setPublicMintActive();
      const txn = await nftContract.mint("ibelick", { value: unitPrice });
      await txn.wait();
    } catch (error) {
      assert(error);
    }
  });

  it("should set beneficiary", async () => {
    await nftContract.setBeneficiary(beneficiary.address, {
      from: owner.address,
    });
  });

  it("should fail set beneficiary & mint active", async () => {
    await nftContract.setBeneficiary(beneficiary.address, {
      from: owner.address,
    });
    expect(await nftContract.publicMintActive()).to.equal(false);
    await nftContract.setPublicMintActive();
    expect(await nftContract.publicMintActive()).to.equal(true);
  });

  it("should mint a collectibe", async () => {
    const unitPrice = await nftContract.getUnitPrice();
    await nftContract.setBeneficiary(beneficiary.address, {
      from: owner.address,
    });
    await nftContract.setPublicMintActive();
    const txn = await nftContract.mint("ibelick", { value: unitPrice });
    await txn.wait();
    assert.ok(txn);
  });

  it("should withdraw", async () => {
    const beneficiaryBalanceBefore = await waffle.provider.getBalance(
      beneficiary.address
    );
    expect(beneficiaryBalanceBefore).to.equal(parseEther("10000"));

    const unitPrice = await nftContract.getUnitPrice();
    await nftContract.setBeneficiary(beneficiary.address, {
      from: owner.address,
    });
    await nftContract.setPublicMintActive();
    let txn = await nftContract.mint("ibelick", { value: unitPrice });
    await txn.wait();
    txn = await nftContract.mint("ibelick", { value: unitPrice });
    await txn.wait();
    await nftContract.withdraw();
    const beneficiaryBalanceAfter = await waffle.provider.getBalance(
      beneficiary.address
    );
    const expectedBeneficiaryBalanceAfter = MINT_FEE.mul(2).add(
      beneficiaryBalanceBefore
    );

    expect(beneficiaryBalanceAfter).to.equal(expectedBeneficiaryBalanceAfter);
  });
});
