// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {ERC1967Proxy} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Implementation} from "../test/Implementation.sol";
import {VersionControlUpgradeable} from "../src/VersionControlUpgradeable.sol";

/**
 * @title DeployScript
 * @dev Script to deploy the upgradeable implementation with a proxy
 */
contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy the implementation contract
        Implementation implementation = new Implementation();
        
        // Prepare the initialization data (owner setting)
        bytes memory initData = abi.encodeCall(
            VersionControlUpgradeable.initialize,
            (deployer)
        );
        
        // Deploy the proxy pointing to the implementation with init data
        ERC1967Proxy proxy = new ERC1967Proxy(
            address(implementation),
            initData
        );
        
        // Log the addresses
        console.log("Implementation deployed at:", address(implementation));
        console.log("Proxy deployed at:", address(proxy));
        
        // Set some initial values through the proxy
        Implementation(address(proxy)).setMessage("Initial message");
        Implementation(address(proxy)).setValue(42);
        
        vm.stopBroadcast();
    }
} 