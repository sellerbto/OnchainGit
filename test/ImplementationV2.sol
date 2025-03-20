// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Implementation} from "./Implementation.sol";

/**
 * @title ImplementationV2
 * @dev An upgraded implementation contract with additional functionality
 */
contract ImplementationV2 is Implementation {
    // Additional state variables
    uint256 public timestamp;
    address public lastCaller;
    
    // Events
    event TimestampUpdated(uint256 oldTimestamp, uint256 newTimestamp);
    
    /**
     * @dev Updates the timestamp to the current block timestamp
     */
    function updateTimestamp() external {
        uint256 oldTimestamp = timestamp;
        timestamp = block.timestamp;
        lastCaller = msg.sender;
        emit TimestampUpdated(oldTimestamp, timestamp);
    }
    
    /**
     * @dev Gets combined data from the contract
     * @return The message, value, timestamp, and last caller as a tuple
     */
    function getCombinedData() external view returns (string memory, uint256, uint256, address) {
        return (message, value, timestamp, lastCaller);
    }
} 