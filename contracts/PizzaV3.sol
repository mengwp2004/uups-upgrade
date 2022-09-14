// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./Pizza.sol";

contract PizzaV3 is Pizza {
    uint256 start;
    ///@dev increments the slices when called
    function refillSlice() external {
        slices += 1;
    }

    function incStart() external {
        start += 1;
    }
    ///@dev returns the contract version
    function pizzaVersion() external pure returns (uint256) {
        return 2;
    }
}
