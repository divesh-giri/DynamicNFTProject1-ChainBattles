const hre = require("hardhat");

async function main() {
  const nftContractFactory = await hre.ethers.getContractFactory(
    "ChainBattles"
  );
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();

  console.log("Contract Successfully Deployed at:", nftContract.address);
  process.exit(0);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
