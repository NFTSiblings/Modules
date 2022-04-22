// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract PaymentSplitter {

    /**
    * @dev Evenly divides and distributes sent Ether among provided
    * addresses.
    */
    function splitPayment(address[] calldata recipients) public payable {
        require(msg.value > 0, "PaymentSplitter: No Ether sent");
        for (uint i = 0; i < recipients.length; i++) {
            payable(recipients[i]).transfer(msg.value / recipients.length);
        }
    }

}