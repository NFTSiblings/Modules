// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/NFTSiblings/Modules/blob/master/AdminPrivileges.sol";

/**
* @dev Use this contract when you want to have a collector
* burn a token from a different collection. This contract
* is compatible with contracts which import ERC721Burnable
* from OpenZeppelin. Alternatively, this contract can burn
* tokens from any contract which exposes a function called
* {burn}.
*
* Tokens which will burned are referred to in this
* contract as kindling.
*/
contract BurnExternal is AdminPrivileges {
    address private kindlingContractAddress;

    constructor(address _kindlingContractAddress) {
        updateKindlingContract(_kindlingContractAddress);
    }

    /**
    * @dev Update contract address of tokens to be burned.
    */
    function updateKindlingContract(address _kindlingContractAddress) public onlyAdmins {
        kindlingContractAddress = _kindlingContractAddress;
    }

    /**
    * @dev Call this function to burn tokens from another
    * collection.
    */
    function burnKindlingTokens(uint256[] calldata tokenIds) internal {
        for (uint i; i < tokenIds.length; i++) {
            BurnInterface(kindlingContractAddress).burn(tokenIds[i]);
        }
    }
}

interface BurnInterface {
    function burn(uint256 tokenId) external;
}