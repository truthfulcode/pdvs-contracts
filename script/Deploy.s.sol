// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {VotingToken} from "../src/VotingToken.sol";
import {VotingStrategy} from "../src/VotingStrategy.sol";
import {ERC20CGPA} from "../src/ERC20CGPA.sol";

contract DeployScript is Script {
    VotingToken vt;
    VotingStrategy vs;
    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PK_ADMIN"));
        address _admin = vm.addr(vm.envUint("PK_ADMIN"));
        address _keeper = vm.addr(vm.envUint("PK_KEEPER"));
        vt = new VotingToken(_admin, _keeper);
        vs = new VotingStrategy(ERC20CGPA(address(vt)));
        vt.setStrategy(vs);
        console.log("VotingToken", address(vt));
        console.log("VotingStrategy", address(vs));
    }
}

contract DeployStrategy is Script {
    VotingToken vt;
    VotingStrategy vs;
    function setUp() public {
        // 1. set Voting Token address
        vt = VotingToken(0x96040854dd0fDB4F2B32F659E9D0e2B7489d419b);
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PK_ADMIN"));
        vs = new VotingStrategy(ERC20CGPA(address(vt)));
        vt.setStrategy(vs);
        console.log("VotingToken", address(vt));
        console.log("VotingStrategy", address(vs));
    }
}