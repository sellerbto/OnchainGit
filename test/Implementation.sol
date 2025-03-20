// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {VersionControlUpgradeable} from "../src/VersionControlUpgradeable.sol";

/**
 * @title Implementation
 * @dev A sample implementation contract that extends the version control system
 */
contract Implementation is VersionControlUpgradeable {
    // State variables
    string public message;
    uint256 public value;
    
    // Events
    event MessageUpdated(string oldMessage, string newMessage);
    event ValueUpdated(uint256 oldValue, uint256 newValue);
    
    /**
     * @dev Sets the message value
     * @param newMessage The new message to set
     */
    function setMessage(string memory newMessage) external onlyOwner {
        string memory oldMessage = message;
        message = newMessage;
        emit MessageUpdated(oldMessage, newMessage);
    }
    
    /**
     * @dev Sets the value
     * @param newValue The new value to set
     */
    function setValue(uint256 newValue) external onlyOwner {
        uint256 oldValue = value;
        value = newValue;
        emit ValueUpdated(oldValue, newValue);
    }
} 