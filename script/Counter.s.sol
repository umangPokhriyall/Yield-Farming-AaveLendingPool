// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {YieldFarming} from "../src/YieldFarming.sol";

contract YieldFarmingScript is Script {
    YieldFarming public yieldFarming;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Replace these with actual addresses you want to use
        address lendingPool = 0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9;
        address dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

        yieldFarming = new YieldFarming(lendingPool, dai);

        vm.stopBroadcast();
    }
}
