// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// VotingStrategy interface to customly implement the logic for deriving the voting using CGPA
interface IVotingStrategy {
    function getVotingPower(uint value) external view returns(uint256 votingPower);
}