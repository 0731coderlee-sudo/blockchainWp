// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {ForkTester} from "../src/ForkTester.sol";

contract DeployForkTester is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        console.log("Deploying ForkTester...");
        console.log("Deployer:", vm.addr(deployerPrivateKey));
        console.log("Block Number:", block.number);
        
        ForkTester forkTester = new ForkTester();
        
        console.log("ForkTester deployed at:", address(forkTester));
        
        // 测试基本功能
        (uint256 blockNumber, uint256 timestamp, bytes32 blockHash) = forkTester.getBlockInfo();
        console.log("Current Block Info:");
        console.log("- Block Number:", blockNumber);
        console.log("- Timestamp:", timestamp);
        console.log("- Block Hash:", vm.toString(blockHash));
        
        vm.stopBroadcast();
    }
}