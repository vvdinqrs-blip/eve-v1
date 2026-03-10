# contracts/DiceBot.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IEntropyConsumer } from "@pythnetwork/entropy-sdk-solidity/IEntropyConsumer.sol";
import { IEntropyV2 } from "@pythnetwork/entropy-sdk-solidity/IEntropyV2.sol";

contract TelegramDiceBot is IEntropyConsumer {
    IEntropyV2 entropy;
    mapping(address => DiceState) public diceStates;
    
    struct DiceState {
        uint64 sequenceNumber;
        int256 lastRoll;
    }
    
    address public owner;
    
    constructor(address entropyAddress) payable {
        owner = msg.sender;
        entropy = IEntropyV2(entropyAddress);
    }

    function requestRandomNumber() external payable returns (uint64) {
        uint256 fee = entropy.getFeeV2();
        return entropy.requestV2{ value: fee }();
    }

    function entropyCallback(
        uint64 sequenceNumber,
        address provider,
        bytes32 randomNumber
    ) internal override {
        DiceState state = diceStates[address(msg.sender)];
        int256 roll = mapRandomNumber(randomNumber, 1, 6);
        state.lastRoll = roll;
        state.sequenceNumber = sequenceNumber;
    }

    function getEntropy() internal view override returns (address) {
        return address(entropy);
    }

    function mapRandomNumber(
        bytes32 randomNumber,
        int256 minRange,
        int256 maxRange
    ) internal pure returns (int256) {
        require(minRange <= maxRange, "Invalid range");
        uint256 range = uint256(maxRange - minRange + 1);
        uint256 randomUint = uint256(randomNumber);
        return minRange + int256(randomUint % range);
    }
}
