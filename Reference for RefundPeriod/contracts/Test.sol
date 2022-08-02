// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./RefundPeriod.sol";
import "./ERC721A.sol";

contract Test is RefundPeriod, ERC721A {

    constructor(uint256 price, address[] memory payees, uint256[] memory shares) 
    RefundPeriod(price, payees, shares)
    ERC721A("MyToken", "MTK") {}

    function refund(uint256 amount, uint256[] memory tokenIds) public whenNotPaused {
        require(amount <= balanceOf(msg.sender), "Sender doesn't have enough tokens to redeem");
        require(tokenIds.length == amount, "Improper Input");
        ( , , , address receiverAddress, ) = getRefundPeriod();
        if(receiverAddress == 0x0000000000000000000000000000000000000000) {
            for(uint256 i = 0; i < tokenIds.length; i++) {
                _burn(tokenIds[i], true);
            }
        }
        else {
            for(uint256 i = 0; i < tokenIds.length; i++) {
                transferFrom(msg.sender, receiverAddress, tokenIds[i]);
            }
        }
        _refund(amount);
    }

}