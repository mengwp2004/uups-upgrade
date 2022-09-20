// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

library Claim{
    enum AssetType {ETH, ERC20}

    struct ClaimInfo{
        uint32 balance;  // nft balance in sku
        address token; //pay contract address
        uint256 salt;   // salt
    }

    function hash(ClaimInfo memory data) internal pure returns (bytes32) {
      
      
        
        return keccak256(abi.encode(
                data.balance,
                data.token,
                data.salt
            ));
            
    }
}