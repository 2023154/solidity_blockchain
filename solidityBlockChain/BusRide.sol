// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract SimpleStorage{
    // State variables and functions will go here
    uint256 private storedNumber;

    function store(uint256 _number) public {
        storedNumber = _number;
    }

    function retrieve() public view returns (uint256){
        return storedNumber;
    }
    
}