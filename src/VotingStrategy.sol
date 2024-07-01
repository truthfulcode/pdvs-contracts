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
    uint immutable DECIMALS;
    uint immutable MAX;
    
    constructor (ERC20CGPA _token) {
        uint _maxPerUser = _token.maxPerUser();
        MAX_PER_USER = _maxPerUser;
        MID_RANGE = _maxPerUser / 2;
        DECIMALS = _token.decimals();
        MAX = 100 * 10 ** DECIMALS;
    }

    function _derive(uint value, uint in_min, uint in_max, uint out_min, uint out_max) internal pure returns(uint vp) {
        assert(in_max > in_min);
        assert(out_max > out_min);
        uint in_range = in_max - in_min;
        uint out_range = out_max - out_min;
        vp = ((value - in_min) * out_range) / in_range + out_min;
    } 

    function getVotingPower(uint value) external view override(IVotingStrategy) returns(uint256 votingPower){
        if (value <= MID_RANGE) {
            // 0..200 => 0..1_000
            votingPower = value * 5;
        } else if (value <= 300) {
            // 200..300 => 1_000..3_000
            votingPower = _derive(value, MID_RANGE, 300, MAX / 10, MAX * 3 / 10);
        } else if (value <= 350) {
            // 300..350 => 3_000..5_000
            votingPower = _derive(value, 300, 350, MAX * 3 / 10, MAX / 2);
        } else if (value <= 400) {
            // 300..350 => 5_000..10_000
            votingPower = _derive(value, 350, MAX_PER_USER, MAX / 2, MAX);
        } else {
            votingPower = 0;
        }
    }

}