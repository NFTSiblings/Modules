// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "https://github.com/NFTSiblings/Modules/blob/master/AdminPrivileges.sol";

/**
* @dev Allowlist contract module.
*/
contract Allowlist is AdminPrivileges {
    mapping(address => uint) public allowlist;

    /**
    * @dev Adds one to the number of allowlist places
    * that each provided address is entitled to.
    */
    function addToAllowlist(address[] calldata _addr) public onlyAdmins {
        for (uint i; i < _addr.length; i++) {
            allowlist[_addr[i]]++;
        }
    }

    /**
    * @dev Sets the number of allowlist places for
    * the given address.
    */
    function setAllowlist(address _addr, uint amount) public onlyAdmins {
        allowlist[_addr] = amount;
    }

    /**
    * @dev Removes all allowlist places for given
    * addresses - they will no longer be allowed.
    */
    function removeFromAllowList(address[] calldata _addr) public onlyAdmins {
        for (uint i; i < _addr.length; i++) {
            allowlist[_addr[i]] = 0;
        }
    }

    /**
    * @dev Add this modifier to a function to require
    * that the msg.sender is on the allowlist.
    */
    modifier requireAllowlist() {
        require(allowlist[msg.sender] > 0);
        _;
    }
}