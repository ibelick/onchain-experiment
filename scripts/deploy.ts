import { ethers } from "hardhat";
import { BigNumber } from "ethers";

const parseEther = (amount: string) => {
  return BigNumber.from(ethers.utils.parseEther(amount));
};

const MINT_FEE = parseEther("0.003");

async function main() {
  // const [owner] = await ethers.getSigners();
  const nftContractFactory = await ethers.getContractFactory(
    "CollectibleOnChain"
  );
  const nftGenerator = await (
    await ethers.getContractFactory("CollectibleGenerator")
  ).deploy();
  console.log("Contract deployed to:", nftGenerator.address);
  const nftContract = await nftContractFactory.deploy(
    nftGenerator.address,
    MINT_FEE,
    200
  );
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // const unitPrice = await nftContract.getUnitPrice();
  // console.log("unitPrice", unitPrice);
  // await nftContract.setBeneficiary(owner.address);
  // await nftContract.setPublicMintActive();
  // const txn = await nftContract.mint("ibelick", { value: unitPrice });
  // await txn.wait();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
