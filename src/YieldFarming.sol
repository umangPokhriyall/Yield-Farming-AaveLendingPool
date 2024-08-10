// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@penzeppelin/contracts/token/ERC20/IERC20.sol";

interface IAaveLendingPool {
    function deposit(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
    function withdraw(address asset, uint256 amount, address to) external returns (uint256);
}

contract YieldFarming {
    IAaveLendingPool public lendingPool;
    IERC20 public dai;

    mapping (address => uint256) public balance;

    constructor(address _lendingPool, address dai) {
        lendingPool = IAaveLendingPool(lendingPool);
        dai = IERC20(dai);
    }

    function deposit(uint256 amount) external {
        dai.transferFrom(msg.sender, address(lendingPool), amount);
        dai.approve(address(lendingPool), amount);
        lendingPool.deposit(address(dai), amount, address(this), 0);
        balance[msg.sender] += amount;
    }

    function withdraw(uint256 amount) external {
        require(balance[msg.sender] >= amount, "Insufficient Balance");
        balance[msg.sender] -= amount;
        lendingPool.withdraw(address(dai), amount, msg.sender);
    } 
}


 