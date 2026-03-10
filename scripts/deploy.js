# scripts/deploy.js
// Contract deployment script
require("hardhat");

async function main() {
  console.log("Deploying TelegramDiceBot contract...");
  
  const artifact = await hre.ethers.getContractFactory("TelegramDiceBot");
  const DiceBot = artifact;
  
  const entropyAddress = process.env.ENTROPY_CONTRACT || "0x...";
  
  const tx = await DiceBot.deploy(entropyAddress, { value: "1 ether" });
  console.log("Contract deployed to:", tx.target);
  
  const receipt = await tx.wait();
  console.log("Transaction hash:", receipt.transactionHash);
}

main().catch(console.error);
