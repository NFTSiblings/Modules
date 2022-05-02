// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/NFTSiblings/Modules/blob/master/AdminPrivileges.sol";

contract AdminPause is AdminPrivileges {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool public paused;

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        require(!paused || isAdmin(msg.sender), "AdminPausable: contract is paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        require(paused || isAdmin(msg.sender), "AdminPausable: contract is not paused");
        _;
    }

    /**
    * @dev Toggle paused state.
    */
    function togglePause() public onlyAdmins {
        paused = !paused;
        if (paused) {
            emit Paused(msg.sender);
        } else {
            emit Unpaused(msg.sender);
        }
    }
}