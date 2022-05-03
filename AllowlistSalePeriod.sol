// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/NFTSiblings/Modules/blob/master/AdminPrivileges.sol";

/**
 * @dev Contract module which facilitates an 'allowlist' sale period prior to a public sale.
 *
 * Inheriting from `ALSalePeriod` will make the {onlyDuringALPeriod} & {onlyDuringPublicSale}
 * modifiers available. {onlyDuringALPeriod} restricts a function from being called any time
 * except for the pre-defined allowlist sale period. {onlyDuringPublicSale} restricts a
 * function from being called until the allowlist sale period has concluded.
 * 
 * Provide the number of hours that the whitelist sale should occur for as an argument to
 * the constructor.
 * 
 * Contract admins can run {beginALSale} function to begin the allowlist sale period,
 * public sale period begins automatically after the end of the allowlist sale period.
 */
contract ALSalePeriod is AdminPrivileges {
    uint public alSaleLength;
    uint private saleTimestamp;

    constructor(uint _alSaleHours) {
        setALSaleLengthHours(_alSaleHours);
    }

    /**
    * @dev Begins allowlist sale period.
    */
    function beginALSale() public onlyAdmins {
        saleTimestamp = block.timestamp;
    }

    /**
    * @dev Updates allowlist sale period length.
    */
    function setALSaleLengthHours(uint length) public onlyAdmins {
        alSaleLength = length * 3600;
    }

    /**
    * @dev Returns bool indicating whether the allowlist
    * sale phase is currently active.
     */
    function isAllowlistSaleActive() public view returns (bool) {
        return saleTimestamp != 0 && block.timestamp < saleTimestamp + alSaleLength;
    }

    /**
    * @dev Returns bool indicating whether the public sale
    * phase is currently active.
     */
    function isPublicSaleActive() public view returns (bool) {
        return block.timestamp > saleTimestamp + alSaleLength;
    }

    /**
    * @dev Restricts functions from being called except for during the allowlist
    * sale period.
    */
    modifier onlyDuringALPeriod() {
        require(
            saleTimestamp != 0 && block.timestamp < saleTimestamp + alSaleLength,
            "ALSalePeriod: This function may only be run during the allowlist sale period."
        );
        _;
    }

    /**
    * @dev Restricts a function from being called except after the allowlist
    * sale period has ended.
    */
    modifier onlyDuringPublicSale() {
        require(
            saleTimestamp != 0 && block.timestamp >= saleTimestamp + alSaleLength,
            "ALSalePeriod: This function may only be run after the allowlist sale period is over."
        );
        _;
    }
}