// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
* @dev Contract for burning tokens from an external collection.
*
* Token owners must approve your contract as an operator for
* their tokens before your contract will be able to burn them.
*
* This contract is compatible with contracts which utilise the
* ERC721Burnable and ERC1155Burnable extensions. Alternatively,
* this contract will work with contracts which expose a {burn}
* function with the correct input params.
*/

contract BurnExternal {

    /**
    * @dev Call this function to burn tokens from an ERC721
    * collection.
    *
    * Specify the address of the collection to be burned and
    * the token IDs.
    *
    * The msg.sender must own the tokens that are to be
    * burned.
    */
    function burnKindlingERC721(address kindlingAddress, uint256[] memory tokenIds) internal {
        for (uint i; i < tokenIds.length; i++) {
            IERC721(kindlingAddress).burn(tokenIds[i]);
        }
    }

    /**
    * @dev Call this function to burn tokens from an ERC1155
    * collection.
    *
    * Specify the address of the collection to be burned, the
    * owner of the tokens, the token ID, and the amount of
    * tokens to be burned.
    *
    * The msg.sender must own the tokens that are to be
    * burned.
    */
    function burnKindlingERC1155(address kindlingAddress, address owner, uint256 tokenId, uint256 amount) internal {
        IERC1155(kindlingAddress).burn(owner, tokenId, amount);
    }
}

interface IERC721 {
    function burn(uint256 tokenId) external;
}

interface IERC1155 {
    function burn(address account, uint256 id, uint256 value) external;
}