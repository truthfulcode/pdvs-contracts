// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {VotingToken} from "../src/VotingToken.sol";

contract DeployScript is Script {
    VotingToken vt;
    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PK_ADMIN"));
        address _admin = vm.addr(vm.envUint("PK_ADMIN"));
        address _keeper = vm.addr(vm.envUint("PK_KEEPER"));
        vt = new VotingToken(_admin, _keeper);
    }
}