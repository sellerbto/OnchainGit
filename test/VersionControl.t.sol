// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {ERC1967Proxy} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {VersionControlUpgradeable} from "../src/VersionControlUpgradeable.sol";
import {Implementation} from "./Implementation.sol";
import {ImplementationV2} from "./ImplementationV2.sol";

contract VersionControlTest is Test {
    VersionControlUpgradeable proxy;
    Implementation implementation;
    ImplementationV2 implementationV2;
    address owner;
    
    function setUp() public {
        owner = makeAddr("owner");
        vm.startPrank(owner);
        
        implementation = new Implementation();
        
        bytes memory initData = abi.encodeCall(
            VersionControlUpgradeable.initialize,
            (owner)
        );
        
        ERC1967Proxy proxyContract = new ERC1967Proxy(
            address(implementation),
            initData
        );
        
        proxy = VersionControlUpgradeable(address(proxyContract));
        
        Implementation(address(proxy)).setMessage("Initial message");
        Implementation(address(proxy)).setValue(42);
        
        vm.stopPrank();
    }
    
    function testInitialState() public {
        assertEq(proxy.owner(), owner);
        assertEq(proxy.getCurrentImplementation(), address(implementation));
        assertEq(proxy.getVersionCount(), 1);
        assertEq(proxy.currentVersionIndex(), 0);
        assertEq(Implementation(address(proxy)).message(), "Initial message");
        assertEq(Implementation(address(proxy)).value(), 42);
    }
    
    function testUpgrade() public {
        vm.startPrank(owner);
        
        implementationV2 = new ImplementationV2();
        
        proxy.upgradeTo(address(implementationV2));
        
        assertEq(proxy.getCurrentImplementation(), address(implementationV2));
        assertEq(proxy.getVersionCount(), 2);
        assertEq(proxy.currentVersionIndex(), 1);
        
        assertEq(Implementation(address(proxy)).message(), "Initial message");
        assertEq(Implementation(address(proxy)).value(), 42);
        
        ImplementationV2(address(proxy)).updateTimestamp();
        assertGt(ImplementationV2(address(proxy)).timestamp(), 0);
        assertEq(ImplementationV2(address(proxy)).lastCaller(), owner);
        
        vm.stopPrank();
    }
    
    function testRollback() public {
        vm.startPrank(owner);
        
        implementationV2 = new ImplementationV2();
        
        console.log("Version count before upgrade:", proxy.getVersionCount());
        console.log("Current version index before upgrade:", proxy.currentVersionIndex());
        
        proxy.upgradeTo(address(implementationV2));
        
        console.log("Version count after upgrade:", proxy.getVersionCount());
        console.log("Current version index after upgrade:", proxy.currentVersionIndex());
        
        ImplementationV2(address(proxy)).updateTimestamp();
        ImplementationV2(address(proxy)).setMessage("V2 message");
        ImplementationV2(address(proxy)).setValue(100);
        
        proxy.rollbackTo(0);
        
        console.log("Version count after rollback:", proxy.getVersionCount());
        console.log("Current version index after rollback:", proxy.currentVersionIndex());
        
        assertEq(proxy.getCurrentImplementation(), address(implementation));
        assertEq(proxy.currentVersionIndex(), 0);
        
        assertEq(Implementation(address(proxy)).message(), "V2 message");
        assertEq(Implementation(address(proxy)).value(), 100);
        
        vm.expectRevert();
        ImplementationV2(address(proxy)).updateTimestamp();
        
        vm.stopPrank();
    }
    
    function testNonOwnerCannotUpgrade() public {
        address nonOwner = makeAddr("nonOwner");
        vm.startPrank(nonOwner);
        
        implementationV2 = new ImplementationV2();
        
        vm.expectRevert();
        proxy.upgradeTo(address(implementationV2));
        
        vm.stopPrank();
    }
    
    function testNonOwnerCannotRollback() public {
        vm.prank(owner);
        implementationV2 = new ImplementationV2();
        
        vm.prank(owner);
        proxy.upgradeTo(address(implementationV2));
        
        address nonOwner = makeAddr("nonOwner");
        vm.prank(nonOwner);
        
        vm.expectRevert();
        proxy.rollbackTo(0);
    }
    
    function testCannotRollbackToInvalidVersion() public {
        vm.startPrank(owner);
        
        vm.expectRevert("Version index out of bounds");
        proxy.rollbackTo(99);
        
        vm.stopPrank();
    }
    
    function testCannotRollbackToCurrentVersion() public {
        vm.startPrank(owner);
        
        vm.expectRevert("Cannot rollback to current version");
        proxy.rollbackTo(0);
        
        vm.stopPrank();
    }
} 