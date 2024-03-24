// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/SrDegenDrink.sol";
import "../src/ERC20Dummy.sol";


contract Deploy is Script {
    function setUp() public {}

    function run() public {

         vm.startBroadcast();
        address tokenAddress = vm.envAddress("TOKEN_ADDRESS");
        SrDegenDrink drink = new SrDegenDrink(ERC20(tokenAddress));
    
        console.logString(
            string.concat(
                "SrDegenDrink deployed at: ", vm.toString(address(drink))
            )
        );
            vm.stopBroadcast();
    }
}
