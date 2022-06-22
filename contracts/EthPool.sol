// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

contract EthPool is
    AccessControlEnumerableUpgradeable,
    ReentrancyGuardUpgradeable
{
    bytes32 private constant STAKER_ROLE = keccak256("STAKER_ROLE");
    bytes32 private constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    struct RewardPool {
        uint lastDepositAt;
    }

    struct StakePool {
        mapping (address => Staker) stakers;
        uint amountOfStakers;
    }

    struct Staker {
        uint amount;
        uint firstDepositAt;
    }

    RewardPool private rewardPool;
    StakePool private stakePool;

    event DepositRewardPool(
        address indexed from,
        uint amount,
        uint balance
    );

    function initialize(
        address _admin
    ) external initializer {
        __ReentrancyGuard_init();
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, _admin);
    }

    function depositRewardPool() public payable {
        require(hasRole(ADMIN_ROLE, msg.sender));

        payable(msg.sender).transfer(msg.value);

        uint currentBalance = address(this).balance;

        rewardPool.lastDepositAt = block.timestamp;

        emit DepositRewardPool(msg.sender, msg.value, currentBalance);
    }

    function deposit() public payable {
        if (stakePool.stakers[msg.sender].firstDepositAt == 0) {
            stakePool.stakers[msg.sender] = Staker(msg.value, block.timestamp);
            _grantRole(STAKER_ROLE, msg.sender);
        } else {
            stakePool.stakers[msg.sender].amount += msg.value;
        }

        stakePool.amountOfStakers += 1;
    }

    function withdraw() public payable {
        require(hasRole(STAKER_ROLE, msg.sender));
        require(stakePool.stakers[msg.sender].firstDepositAt < rewardPool.lastDepositAt);

        uint amountToWithdraw = stakePool.stakers[msg.sender].amount;

        amountToWithdraw += address(this).balance / stakePool.amountOfStakers;
    }
}