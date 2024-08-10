// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/YieldFarming.sol";

contract YieldFarmingTest is Test {
    YieldFarming public yieldFarming;
    IERC20 public dai;
    IAaveLendingPool public lendingPool;

    address private constant DAI_MAINNET = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant AAVE_LENDING_POOL = 0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9;

    function setUp() public {
        vm.createFork("https://mainnet.infura.io/v3/ea32d7cf31f24efe95db13a5b7357cd8");
        vm.selectFork(0);

        dai = IERC20(DAI_MAINNET);
        yieldFarming = new YieldFarming(AAVE_LENDING_POOL, DAI_MAINNET);
        lendingPool = IAaveLendingPool(AAVE_LENDING_POOL); 

    }
    function testDeposit() public {
        uint256 depositAmount = 1000 * 10**18;

        vm.deal(address(this), depositAmount);
        dai.approve(address(yieldFarming), depositAmount);
        yieldFarming.deposit(depositAmount);
        assertEq(yieldFarming.balance(address(this)), depositAmount);
    }

    function testWithdraw() public {
        uint256 depositAmount = 1000 * 10**18;

        dai.approve(address(yieldFarming), depositAmount);
        yieldFarming.deposit(depositAmount);

        yieldFarming.withdraw(amount);
        assertEq(yieldFarming.balances(address(this)), 0);

    }

}

