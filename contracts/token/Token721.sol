// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/metatx/ERC2771ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";

contract Token721 is
    ERC721EnumerableUpgradeable,
    ReentrancyGuardUpgradeable,
    ERC2771ContextUpgradeable,
    AccessControlEnumerableUpgradeable
{
    bytes32 private constant ADMIN_ROLE = keccak256("MINTER_ROLE");
    bytes32 private constant MINTER_ROLE = keccak256("ADMIN_ROLE");
    uint256 public maxWalletClaimCount;
    uint256 public maxTotalSupply;

    mapping(address => uint256) public walletClaimCount;

    constructor(address trustedForwarder) ERC2771ContextUpgradeable(trustedForwarder) {}

    function initialize(
        address _admin,
        string memory _name,
        string memory _symbol
    ) external initializer {
        __ReentrancyGuard_init();

        __ERC721_init(_name, _symbol);

        _setupRole(ADMIN_ROLE, _admin);
        _setupRole(MINTER_ROLE, _admin);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721EnumerableUpgradeable, AccessControlEnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _msgSender()
        internal
        view
        virtual
        override(ContextUpgradeable, ERC2771ContextUpgradeable)
        returns (address sender)
    {
        return ERC2771ContextUpgradeable._msgSender();
    }

    function _msgData()
        internal
        view
        virtual
        override(ContextUpgradeable, ERC2771ContextUpgradeable)
        returns (bytes calldata)
    {
        return ERC2771ContextUpgradeable._msgData();
    }
}
