// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Contract module that stores an address as an 'owner'
 * and addresses as 'admins'.
 *
 * Inheriting from `AdminPrivileges` will make the
 * {onlyAdmins} modifier available, which can be applied to
 * functions to restrict all wallets except for the stored
 * owner and admin addresses.
 */
contract AdminPrivileges {
    address public _owner;

    mapping(address => bool) public admins;

    constructor() {
        _owner = msg.sender;
    }

    /**
    * @dev Returns true if provided address has admin status
    * or is the contract owner.
    */
    function isAdmin(address _addr) public view returns (bool) {
        return _owner == _addr || admins[_addr];
    }

    /**
    * @dev Prevents a function from being called by anyone
    * but the contract owner or approved admins.
    */
    modifier onlyAdmins() {
        require(isAdmin(msg.sender), "AdminPrivileges: caller is not an admin");
        _;
    }

    /**
    * @dev Toggles admin status of provided addresses.
    */
    function toggleAdmins(address[] calldata accounts) external onlyAdmins {
        for (uint i; i < accounts.length; i++) {
            if (admins[accounts[i]]) {
                delete admins[accounts[i]];
            } else {
                admins[accounts[i]] = true;
            }
        }
    }
}