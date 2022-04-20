// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "https://github.com/NFTSiblings/Smart-Contract-Templates/blob/master/Module%20Contracts/AdminPrivileges.sol";

/**
 * @dev Contract module which facilitates a 'whitelist' sale period prior to a public sale.
 *
 * Inheriting from `WLSalePeriod` will make the {onlyDuringWLPeriod} & {onlyDuringPublicSale}
 * modifiers available. {onlyDuringWLPeriod} restricts a function from being called any time
 * except for the pre-defined whitelist sale period. {onlyDuringPublicSale} restricts a
 * function from being called until the whitelist sale period has concluded.
 * 
 * The length of the whitelist sale period is declared as an argument in the constructor in
 * the form of an integer as a Unix timestamp. You can calculate time values and read more
 * about Unix timestamp at https://www.unixtimestamp.com/
 * 
 * Contract admins can run {beginWLSale} function to begin the whitelist sale period,
 * public sale period begins automatically after the end of the whitelist sale period.
 *
 * This contract inherits from the AdminPrivileges contract - make sure to import that
 * first.
 */
contract WLSalePeriod is AdminPrivileges {
    // 1 day == 86400
    // 1 hour == 3600

    uint public wlSaleLength;
    uint saleTimestamp;

    constructor(uint _wlSaleLength) {
        wlSaleLength = _wlSaleLength;
    }

    /**
    * @dev Begins whitelist sale period.
    */
    function beginWLSale() public onlyAdmins {
        saleTimestamp = block.timestamp;
    }

    /**
    * @dev Updates whitelist sale period length.
    */
    function setWLSaleLength(uint length) public onlyAdmins {
        wlSaleLength = length;
    }

    /**
    * @dev Restricts functions from being called except for during the whitelist
    * sale period.
    */
    modifier onlyDuringWLPeriod() {
        require(
            saleTimestamp != 0 && block.timestamp < saleTimestamp + wlSaleLength,
            "WLSalePeriod: This function may only be run during the whitelist sale period."
        );
        _;
    }

    /**
    * @dev Restricts a function from being called except after the whitelist
    * sale period has ended.
    */
    modifier onlyDuringPublicSale() {
        require(
            saleTimestamp != 0 && block.timestamp >= saleTimestamp + wlSaleLength,
            "WLSalePeriod: This function may only be run after the whitelist sale period is over."
        );
        _;
    }
}