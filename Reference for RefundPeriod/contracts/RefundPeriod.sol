//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@siblings/modules/AdminPause.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";

contract RefundPeriod is AdminPause, PaymentSplitter {
    
    struct refundPeriodStateVariables {
        uint256 startingBlock;
        uint256 endingBlock;
        uint256 price;
        address receiverAddress;
        bool initialized;
    }

    refundPeriodStateVariables private refundPeriod;

    constructor(uint256 price, address[] memory payees, uint256[] memory shares) 
    PaymentSplitter(payees, shares) 
    {
        refundPeriod.price = price;
    }

    // INITIALIZING FUNCTIONS //

    function initialize(uint256 startingBlock, uint256 endingBlock, address receiverAddress) public virtual onlyAdmins {
        require(startingBlock <= endingBlock, "endingBlock cannot be before startingBlock");
        refundPeriod.startingBlock = startingBlock;
        refundPeriod.endingBlock = endingBlock;
        refundPeriod.receiverAddress = receiverAddress;
        refundPeriod.initialized = true;
    }
    function initialize(uint256 startingBlock, uint256 endingBlock) public virtual onlyAdmins { 
        require(startingBlock <= endingBlock, "endingBlock cannot be before startingBlock");
        refundPeriod.startingBlock = startingBlock;
        refundPeriod.endingBlock = endingBlock;
        refundPeriod.receiverAddress = 0x0000000000000000000000000000000000000000;
        refundPeriod.initialized = true;
    }

    // UPDATING FUNCTIONS //

    function updateRefundPeriod(uint256 startingBlock, uint256 endingBlock) public virtual isInitialized onlyAdmins {
        require(refundPeriod.startingBlock != startingBlock || refundPeriod.endingBlock != endingBlock, "Same values");
        require(startingBlock <= endingBlock, "endingBlock cannot be before startingBlock");
        refundPeriod.startingBlock = startingBlock;
        refundPeriod.endingBlock = endingBlock;
    }

    function updateRefundPeriod(address receiverAddress) public virtual isInitialized onlyAdmins {
        require(receiverAddress != refundPeriod.receiverAddress, "Same values");
        refundPeriod.receiverAddress = receiverAddress;
    }

    function updateRefundPeriod(uint256 price) public virtual isInitialized onlyAdmins {
        refundPeriod.price = price;
    }

    // REFUND FUNCTION //

    function _refund(uint256 amount) internal whenNotPaused isRefundPeriodGoingOn {
        Address.sendValue(payable (msg.sender), amount*refundPeriod.price);
    }

    function _refund(IERC20 token, uint256 amount) internal whenNotPaused isRefundPeriodGoingOn {
        SafeERC20.safeTransfer(token, msg.sender, amount*refundPeriod.price);
    }

    // GETTER FUNCTION //

    function getRefundPeriod() public view returns(uint256 startingBlock, uint256 endingBlock,  uint256 price, address receiverAddress, bool initialized) {
        startingBlock = refundPeriod.startingBlock;
        endingBlock = refundPeriod.endingBlock;
        price = refundPeriod.price;
        receiverAddress = refundPeriod.receiverAddress;
        initialized = refundPeriod.initialized;
    }

    // PAYMENTSPLITTER IMPLEMENTATION //


    // Not sure whether it's a good idea to keep the whenNotPaused modifier here

    function release(address payable account) public override whenNotPaused isRefundPeriodOver() {
        super.release(account);
    }

    function release(IERC20 token, address account) public override whenNotPaused isRefundPeriodOver() {
        super.release(token, account);
    }

    // MODIFIERS //

    modifier isInitialized() {
        require(refundPeriod.initialized, "RefundPeriod Module has not been initialized yet");
        _;
    }

    modifier isRefundPeriodOver() {
        require(refundPeriod.initialized, "RefundPeriod Module has not been initialized yet");
        require(block.number > refundPeriod.endingBlock, "RefundPeriod is not over yet");
        _;
    }

    modifier isRefundPeriodGoingOn() {
        require(refundPeriod.initialized, "RefundPeriod Module has not been initialized yet");
        require(block.number >= refundPeriod.startingBlock && block.number <= refundPeriod.endingBlock , "RefundPeriod is not over yet");
        _;
    }

}