// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Implementation} from "../test/Implementation.sol";
import {ImplementationV2} from "../test/ImplementationV2.sol";
import {VersionControlUpgradeable} from "../src/VersionControlUpgradeable.sol";

/**
 * @title UpgradeScript
 * @dev Script to upgrade the implementation to a new version
 */
contract UpgradeScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address proxyAddress = vm.envAddress("PROXY_ADDRESS");
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy the new implementation
        ImplementationV2 implementationV2 = new ImplementationV2();
        console.log("New implementation deployed at:", address(implementationV2));
        
        // Get the proxy instance
        VersionControlUpgradeable proxy = VersionControlUpgradeable(proxyAddress);
        
        // Check the current implementation
        address currentImpl = proxy.getCurrentImplementation();
        console.log("Current implementation:", currentImpl);
        
        // Get the current value
        uint256 currentValue = Implementation(proxyAddress).value();
        string memory currentMessage = Implementation(proxyAddress).message();
        console.log("Current value:", currentValue);
        console.log("Current message:", currentMessage);
        
        // Upgrade to the new implementation
        proxy.upgradeTo(address(implementationV2));
        console.log("Proxy upgraded to new implementation");
        
        // Verify the upgrade
        address newImpl = proxy.getCurrentImplementation();
        console.log("New implementation:", newImpl);
        
        // Use new functionality in the upgraded contract
        ImplementationV2(proxyAddress).updateTimestamp();
        
        // Get the V2 state
        uint256 timestamp = ImplementationV2(proxyAddress).timestamp();
        address lastCaller = ImplementationV2(proxyAddress).lastCaller();
        console.log("Timestamp set to:", timestamp);
        console.log("Last caller:", lastCaller);
        
        vm.stopBroadcast();
    }
} 