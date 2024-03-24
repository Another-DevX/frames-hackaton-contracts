// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/SrDegenDrink.sol";
import "../src/ERC20Dummy.sol";


contract Deploy is Script {
    function setUp() public {}

    function run() public {

         vm.startBroadcast();
        SrDegenDrink drink = new SrDegenDrink(ERC20(0x4ed4E862860beD51a9570b96d89aF5E1B0Efefed));



        console.logString(
            string.concat(
                "SrDegenDrink deployed at: ", vm.toString(address(drink))
            )
        );
            vm.stopBroadcast();
    }
}
