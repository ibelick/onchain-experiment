import { ethers } from "hardhat";
import { Contract } from "ethers";
import assert from "assert";

const { expect } = require("chai");
// import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

const ether = 1e18;

describe("CollectibleOnChain", () => {
  let nftContract: Contract;
  // let owner: SignerWithAddress;
  // let address1: SignerWithAddress;

  beforeEach(async () => {
    const nftContractFactory = await ethers.getContractFactory(
      "CollectibleOnChain"
    );
    nftContract = await nftContractFactory.deploy(1e18 * 0.003, 200);
    await nftContract.deployed();
    assert.ok(nftContract.address);
  });

  it("should have a price of 0.003 ether", async () => {
    const unitPrice = await nftContract.getUnitPrice();
    assert.equal(unitPrice, (0.003 * ether).toString());
  });

  // it should fail to mint when public mint is not active
  it("should fail to mint when sale is not started", async () => {
    const unitPrice = await nftContract.getUnitPrice();
    await nftContract.mint(1, { value: unitPrice });
  });

  it("should set public mint active", async () => {
    expect(await nftContract.publicMintActive()).to.equal(false);
    await nftContract.setPublicMintActive();
    expect(await nftContract.publicMintActive()).to.equal(true);
  });

  it("Should mint an collectibe", async () => {
    const unitPrice = await nftContract.getUnitPrice();
    await nftContract.setPublicMintActive();
    const txn = await nftContract.mint("ibelick", { value: unitPrice });
    await txn.wait();
    console.log("Minted NFT #1");
  });
});
