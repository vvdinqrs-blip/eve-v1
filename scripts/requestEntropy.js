# scripts/requestEntropy.js
// Script to request random numbers
const hre = require("hardhat");

async function main() {
  const DiceBot = await hre.ethers.getContractFactory("TelegramDiceBot");
  
  const contractAddress = process.env.CONTRACT_ADDRESS || "0x...";
  const diceBot = new hre.ethers.Contract(contractAddress, DiceBot.interface);
  
  await diceBot.requestRandomNumber();
  console.log("Entropy request submitted!");
}

main().catch(console.error);
