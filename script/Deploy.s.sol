// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/SrDegenDrink.sol";
import "../src/ERC20Dummy.sol";


contract Deploy is Script {
    function setUp() public {}

    function run() public {

         vm.startBroadcast();
        ERC20Dummy token = new ERC20Dummy(address(this));
        SrDegenDrink drink = new SrDegenDrink(ERC20(token));

        token.approve(address(drink), 1000000* 10**18);


        console.logString(
            string.concat(
                "ERC20Dummy deployed at: ", vm.toString(address(token)),
                "\n SrDegenDrink deployed at: ", vm.toString(address(drink))
            )
        );
            vm.stopBroadcast();
    }
}
