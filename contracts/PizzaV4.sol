// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./Pizza.sol";

contract PizzaV4 is Pizza {
    address start;
    ///@dev increments the slices when called
    function refillSlice() external {
        slices += 1;
    }

    function incStart() external view returns (address){
        return start;
    }
    ///@dev returns the contract version
    function pizzaVersion() external pure returns (uint256) {
        return 2;
    }
}
