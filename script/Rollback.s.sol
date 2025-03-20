// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Implementation} from "../test/Implementation.sol";
import {ImplementationV2} from "../test/ImplementationV2.sol";
import {VersionControlUpgradeable} from "../src/VersionControlUpgradeable.sol";

/**
 * @title RollbackScript
 * @dev Script to rollback to a previous implementation
 */
contract RollbackScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address proxyAddress = vm.envAddress("PROXY_ADDRESS");
        uint256 versionIndex = vm.envUint("VERSION_INDEX");
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Get the proxy instance
        VersionControlUpgradeable proxy = VersionControlUpgradeable(proxyAddress);
        
        // Log the current version info
        address currentImpl = proxy.getCurrentImplementation();
        uint256 currentVersionIndex = proxy.currentVersionIndex();
        uint256 versionCount = proxy.getVersionCount();
        
        console.log("Current implementation:", currentImpl);
        console.log("Current version index:", currentVersionIndex);
        console.log("Total versions:", versionCount);
        
        // Rollback to the specified version
        console.log("Rolling back to version:", versionIndex);
        proxy.rollbackTo(versionIndex);
        
        // Verify the rollback
        address newImpl = proxy.getCurrentImplementation();
        uint256 newVersionIndex = proxy.currentVersionIndex();
        
        console.log("New implementation after rollback:", newImpl);
        console.log("New version index after rollback:", newVersionIndex);
        
        // Try to access the state to verify it's preserved
        try Implementation(proxyAddress).value() returns (uint256 value) {
            console.log("Value after rollback:", value);
        } catch {
            console.log("Could not access value after rollback");
        }
        
        try Implementation(proxyAddress).message() returns (string memory message) {
            console.log("Message after rollback:", message);
        } catch {
            console.log("Could not access message after rollback");
        }
        
        // Try to access V2-specific functions
        try ImplementationV2(proxyAddress).timestamp() returns (uint256 timestamp) {
            console.log("Timestamp after rollback:", timestamp);
            console.log("This is a V2 implementation");
        } catch {
            console.log("Could not access timestamp (not a V2 implementation)");
        }
        
        vm.stopBroadcast();
    }
} 