// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AdminPrivileges.sol";

/**
* @notice THIS PRODUCT IS IN BETA, SIBLING LABS IS NOT RESPONSIBLE FOR ANY LOST FUNDS OR
* UNINTENDED CONSEQUENCES CAUSED BY THE USE OF THIS PRODUCT IN ANY FORM.
*/

/**
 * @dev Contract module which facilitates an allowlist only sale
 * period prior to a public sale.
 *
 * Inheriting from `ALSalePeriod` will make the {onlyDuringALPeriod}
 * & {onlyDuringPublicSale} modifiers available.
 *
 * {onlyDuringALPeriod} restricts a function from being called any
 * time except for the pre-defined allowlist sale period.
 * {onlyDuringPublicSale} restricts a function from being called
 * until the allowlist sale period has concluded.
 * 
 * Provide the number of hours that the whitelist sale should
 * occur for as an argument to the constructor.
 * 
 * Contract admins can run {beginALSale} function to begin the
 * allowlist sale period, public sale period begins
 * automatically after the end of the allowlist sale period.
 *
 * See more module contracts from Sibling Labs at
 * https://github.com/NFTSiblings/Modules
 */
contract ALSalePeriod is AdminPrivileges {
    uint public alSaleLength;
    uint public saleTimestamp;

    constructor(uint _alSaleHours) {
        setALSaleLengthInHours(_alSaleHours);
    }

    /**
    * @dev Begins allowlist sale period. Public sale period
    * automatically begins after allowlist sale period
    * concludes.
    */
    function beginALSale() public onlyAdmins {
        saleTimestamp = block.timestamp;
    }

    /**
    * @dev Updates allowlist sale period length.
    */
    function setALSaleLengthInHours(uint length) public onlyAdmins {
        alSaleLength = length * 3600;
    }

    /**
    * @dev Returns whether the allowlist sale phase is
    * currently active.
     */
    function isAllowlistSaleActive() public view returns (bool) {
        return saleTimestamp != 0 && block.timestamp < saleTimestamp + alSaleLength;
    }

    /**
    * @dev Returns whether the public sale phase is currently
    * active.
     */
    function isPublicSaleActive() public view returns (bool) {
        return saleTimestamp != 0 && block.timestamp >= saleTimestamp + alSaleLength;
    }

    /**
    * @dev Restricts functions from being called except for during
    * the allowlist sale period.
    */
    modifier onlyDuringALPeriod() {
        require(
            isAllowlistSaleActive(),
            "ALSalePeriod: This function may only be run during the allowlist sale period."
        );
        _;
    }

    /**
    * @dev Restricts a function from being called except after the
    * allowlist sale period has ended.
    */
    modifier onlyDuringPublicSale() {
        require(
            isPublicSaleActive(),
            "ALSalePeriod: This function may only be run after the allowlist sale period is over."
        );
        _;
    }
}