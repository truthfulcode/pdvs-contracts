// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./ERC20CGPA.sol";
import "./VotingToken.sol";
import "./IVotingStrategy.sol";

// voting strategy for 4 grading scale CGPA
contract VotingStrategy is IVotingStrategy {
    error InvalidValue();
    uint immutable MID_RANGE;
    uint immutable MAX_PER_USER;
    
    constructor (ERC20CGPA _token) {
        uint _maxPerUser = ERC20CGPA.maxPerUser();
        MAX_PER_USER = _maxPerUser;
        MID_RANGE = _maxPerUser / 2;
    }

    function getVotingPower(uint value) external view override(IVotingStrategy) returns(uint256 votingPower){
        // 200 * 500 = 100_000
        if (value < MID_RANGE) {
            // 201..400 => 1_000_000
            votingPower = value * 500;
        } else if (value <= MAX_PER_USER){
            // to be implemented and maintain 2 decimal point precision

            // votingPower = 0;
        } else {
            revert InvalidValue();
        }
    }
}