// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {VotingToken} from "../src/VotingToken.sol";
import {VotingStrategy} from "../src/VotingStrategy.sol";
import {ERC20CGPA} from "../src/ERC20CGPA.sol";
import {UserType} from "../src/IERC20CGPA.sol";

contract CounterTest is Test {
    VotingToken vt;
    VotingStrategy vs;

    address _admin = vm.addr(1);
    address _keeper = vm.addr(2);

    function setUp() public {
        vt = new VotingToken(_admin, _keeper);
        vs = new VotingStrategy(ERC20CGPA(address(vt)));
        vm.prank(_admin);
        vt.setStrategy(vs);
    }

    function test_Mint_Revoke() public {
        vm.startPrank(_keeper);
        address user = address(50);
        vt.mint(user, 350, UserType.STUDENT);
        vt.revoke(user);
    }
}
