// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/YieldFarming.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract YieldFarmingTest is Test {
    YieldFarming public yieldFarming;
    IERC20 public dai;
    IAaveLendingPool public lendingPool;

    address private constant DAI_MAINNET = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant AAVE_LENDING_POOL = 0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9;

    address private daiHolder = 0x40ec5B33f54e0E8A33A975908C5BA1c14e5BbbDf; // Replace with a real DAI holder address

    function setUp() public {
        // Fork the mainnet
        vm.createFork("https://mainnet.infura.io/v3/ea32d7cf31f24efe95db13a5b7357cd8");
        vm.selectFork(0);

        // Initialize contracts
        dai = IERC20(DAI_MAINNET);
        yieldFarming = new YieldFarming(AAVE_LENDING_POOL, DAI_MAINNET);
        lendingPool = IAaveLendingPool(AAVE_LENDING_POOL); 
    }

    function testDeposit() public {
        uint256 depositAmount = 1000 * 10**18;

        // Display DAI holder balance before transfer
        uint256 daiHolderBalance = dai.balanceOf(daiHolder);
        console.log("DAI Holder Balance before transfer:", daiHolderBalance);

        // Display contract balance before receiving DAI
        uint256 contractBalanceBefore = dai.balanceOf(address(this));
        console.log("Contract DAI Balance before transfer:", contractBalanceBefore);

        // Impersonate a DAI holder and transfer DAI to the test contract
        vm.prank(daiHolder);
        require(dai.transfer(address(this), depositAmount), "DAI transfer failed");

        // Display contract balance after receiving DAI
        uint256 contractBalanceAfter = dai.balanceOf(address(this));
        console.log("Contract DAI Balance after transfer:", contractBalanceAfter);

        uint256 balanceBefore = dai.balanceOf(address(this));
        require(balanceBefore >= depositAmount, "Insufficient DAI balance after transfer");

        require(dai.approve(address(yieldFarming), depositAmount), "DAI approve failed");
        yieldFarming.deposit(depositAmount);

        uint256 balanceAfter = yieldFarming.balance(address(this));
        assertEq(balanceAfter, depositAmount, "Deposit failed");
    }

    function testWithdraw() public {
        uint256 depositAmount = 1000 * 10**18;

        // Display DAI holder balance before transfer
        uint256 daiHolderBalance = dai.balanceOf(daiHolder);
        console.log("DAI Holder Balance before transfer:", daiHolderBalance);

        // Display contract balance before receiving DAI
        uint256 contractBalanceBefore = dai.balanceOf(address(this));
        console.log("Contract DAI Balance before transfer:", contractBalanceBefore);

        // Impersonate a DAI holder and transfer DAI to the test contract
        vm.prank(daiHolder);
        require(dai.transfer(address(this), depositAmount), "DAI transfer failed");

        // Display contract balance after receiving DAI
        uint256 contractBalanceAfter = dai.balanceOf(address(this));
        console.log("Contract DAI Balance after transfer:", contractBalanceAfter);

        require(dai.approve(address(yieldFarming), depositAmount), "DAI approve failed");
        yieldFarming.deposit(depositAmount);

        // Withdraw and check balances
        yieldFarming.withdraw(depositAmount);

        uint256 finalBalance = dai.balanceOf(address(this));
        assertEq(finalBalance, depositAmount, "Withdraw failed");

        uint256 yieldFarmingBalance = yieldFarming.balance(address(this));
        assertEq(yieldFarmingBalance, 0, "YieldFarming balance should be zero after withdrawal");
    }
}
