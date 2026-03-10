# contracts/EntropyHelper.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library EntropyHelper {
    function mapRandomNumber(
        bytes32 randomNumber,
        int256 minRange,
        int256 maxRange
    ) internal pure returns (int256) {
        require(minRange <= maxRange, "Invalid range: min > max");
        uint256 range = uint256(maxRange - minRange + 1);
        uint256 randomUint = uint256(randomNumber);
        return minRange + int256(randomUint % range);
    }

    function generateDiceRoll(bytes32 randomNumber) internal pure returns (int256) {
        return mapRandomNumber(randomNumber, 1, 6);
    }

    function generateBonus(bytes32 randomNumber) internal pure returns (int256) {
        return mapRandomNumber(randomNumber, 0, 100);
    }

    function generateAttributes(bytes32 randomNumber) internal pure returns (
        int256 roll,
        int256 bonus
    ) {
        roll = mapRandomNumber(randomNumber, 1, 6);
        bonus = mapRandomNumber(
            keccak256(abi.encodePacked(randomNumber, "bonus")),
            0, 100
        );
    }
}
