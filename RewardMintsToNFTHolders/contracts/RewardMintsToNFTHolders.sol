//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract RewardMintsToNFTHolders is ERC721 {
    string _baseURI;

    constructor(string calldata baseURI) ERC721("RewardMintsToNFTHolders", "RMNH") {
        _baseURI = baseURI;
    }

    function setBaseURI(string calldata baseURI) external onlyOwner {
        return _baseURI;
    }

    
}
