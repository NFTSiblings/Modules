// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract wlSalePeriod is AdminPrivileges {
    // 1 day == 86400
    // 1 hour == 3600

    uint public wlSaleLength;
    uint saleTimestamp;

    constructor(uint _wlSaleLength) {
        wlSaleLength = _wlSaleLength;
    }

    function beginWLSale() public onlyAdmins {
        saleTimestamp = block.timestamp;
    }

    function setWLSaleLength(uint length) public onlyAdmins {
        wlSaleLength = length;
    }

    modifier onlyDuringWLPeriod() {
        require(
            saleTimestamp != 0 && block.timestamp < saleTimestamp + wlSaleLength,
            "This function may only be run during the whitelist sale period."
        );
        _;
    }

    modifier onlyDuringPublicSale() {
        require(
            saleTimestamp != 0 && block.timestamp >= saleTimestamp + wlSaleLength,
            "This function may only be run after the whitelist sale period is over."
        );
        _;
    }
}