//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.11;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardMintsToNFTHolders is ERC721 {
    string _metadataURI;

    constructor(string calldata metadataURI) ERC721("RewardMintsToNFTHolders", "RMNH") {
        _metadataURI = metadataURI;
    }

    function setmetadataURI(string calldata metadataURI) external onlyOwner {
        return _metadataURI;
    }
}
