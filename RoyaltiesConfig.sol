// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/NFTSiblings/Modules/blob/master/AdminPrivileges.sol";

contract RoyaltiesConfig is AdminPrivileges {
    uint256 private _royaltyBps;
    address payable private _royaltyRecipient;
    bytes4 private constant _INTERFACE_ID_ROYALTIES_EIP2981 = 0x2a55205a;
    bytes4 private constant _INTERFACE_ID_ROYALTIES_RARIBLE = 0xb7799584;

    /**
     * @dev See {IERC165-supportsInterface}. Inherit this function
     * to your base contract to add 
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(AdminControl, ERC721, IERC165) returns (bool) {
        return interfaceId == _INTERFACE_ID_ROYALTIES_EIP2981 || interfaceId == _INTERFACE_ID_ROYALTIES_RARIBLE;
    }

    /**
    * @dev Set royalty details.
     */
    function updateRoyalties(address payable recipient, uint256 bps) external override adminRequired {
        _royaltyRecipient = recipient;
        _royaltyBps = bps;
    }

    // RARIBLE ROYALTIES FUNCTIONS //

    function getFeeRecipients(uint256) external view override returns (address payable[] memory recipients) {
        if (_royaltyRecipient != address(0x0)) {
            recipients = new address payable[](1);
            recipients[0] = _royaltyRecipient;
        }
        return recipients;
    }

    function getFeeBps(uint256) external view override returns (uint[] memory bps) {
        if (_royaltyRecipient != address(0x0)) {
            bps = new uint256[](1);
            bps[0] = _royaltyBps;
        }
        return bps;
    }

    // EIP2981 ROYALTY STANDARD FUNCTION //

    function royaltyInfo(uint256, uint256 value) external view override returns (address, uint256) {
        return (_royaltyRecipient, value*_royaltyBps/10000);
    }
}