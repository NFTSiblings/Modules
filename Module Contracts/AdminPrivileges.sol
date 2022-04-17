// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/**
 * @dev Contract module that stores an address as an 'owner' and addresses as 'admins'.
 *
 * Inheriting from `AdminPrivileges` will make the {onlyAdmins} modifier
 * available, which can be applied to functions to restrict all wallets except for the
 * stored owner and admin addresses.
 */
contract AdminPrivileges {
    address public _owner;

    mapping(address => bool) public admins;

    constructor() {
        _owner = msg.sender;
    }

    /**
    * @dev Prevents a function from being called by anyone but the contract owner or approved admins.
    */
    modifier onlyAdmins() {
        require(_owner == msg.sender || admins[msg.sender], "AdminPrivileges: caller is not an admin");
        _;
    }

    /**
    * @dev Toggles admin status of provided address.
    */
    function toggleAdmin(address account) external onlyAdmins {
        if (admins[account]) {
            delete admins[account];
        } else {
            admins[account] = true;
        }
    }
}