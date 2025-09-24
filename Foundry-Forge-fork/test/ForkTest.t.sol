// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {ForkTester} from "../src/ForkTester.sol";
import "forge-std/interfaces/IERC20.sol";

contract ForkTest is Test {
    ForkTester public forkTester;
    
    // 主网上的知名地址 (有大量代币余额)
    address public constant WHALE_ADDRESS = 0x8EB8a3b98659Cce290402893d0123abb75E3ab28; // 某个有大量USDC的地址
    address public constant VITALIK_ADDRESS = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045; // Vitalik的地址
    
    // 代币地址
    address public constant USDC = 0xa0B86A33e6441C0cB13F6435b9cA20d0D2c3cc90; 
    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    
    uint256 public mainnetFork;
    uint256 public constant FORK_BLOCK_NUMBER = 18500000; // 可以调整这个区块号
    
    function setUp() public {
        // 创建主网Fork
        string memory mainnetUrl = vm.envOr("MAINNET_RPC_URL", string("https://eth-mainnet.alchemyapi.io/v2/demo"));
        
        // 在指定区块高度创建Fork
        mainnetFork = vm.createFork(mainnetUrl, FORK_BLOCK_NUMBER);
        vm.selectFork(mainnetFork);
        
        // 部署测试合约
        forkTester = new ForkTester();
        
        console.log("=== Fork Setup Complete ===");
        console.log("Fork Block Number:", FORK_BLOCK_NUMBER);
        console.log("Current Block Number:", block.number);
        console.log("ForkTester deployed at:", address(forkTester));
    }
    
    /**
     * @dev 测试Fork基本信息
     */
    function test_ForkBasicInfo() public view {
        console.log("\n=== Fork Basic Info Test ===");
        
        (uint256 blockNumber, uint256 timestamp, bytes32 blockHash) = forkTester.getBlockInfo();
        
        console.log("Block Number:", blockNumber);
        console.log("Block Timestamp:", timestamp);
        console.log("Block Hash:", vm.toString(blockHash));
        
        // 验证我们确实在指定的区块上
        assertEq(blockNumber, FORK_BLOCK_NUMBER, "Should be at the forked block number");
        
        // 验证是Fork环境
        assertTrue(forkTester.isForkedNetwork(), "Should detect forked network");
    }
    
    /**
     * @dev 测试检查真实地址的代币余额
     */
    function test_CheckRealBalances() public {
        console.log("\n=== Real Balance Check Test ===");
        
        // 检查Vitalik地址的ETH余额
        uint256 ethBalance = VITALIK_ADDRESS.balance;
        console.log("Vitalik ETH Balance:", ethBalance / 1e18, "ETH");
        
        // 检查各种代币余额
        uint256[] memory balances = forkTester.checkMultipleBalances(VITALIK_ADDRESS);
        
        console.log("USDC Balance:", balances[0]);
        console.log("WETH Balance:", balances[1] / 1e18, "WETH");
        console.log("DAI Balance:", balances[2] / 1e18, "DAI");
        
        // 基本断言 - 应该有一些余额
        assertTrue(ethBalance > 0, "Vitalik should have ETH balance");
    }
    
    /**
     * @dev 测试模拟交易功能
     */
    function test_SimulateTransactions() public {
        console.log("\n=== Transaction Simulation Test ===");
        
        // 找一个有USDC余额的地址进行测试
        address recipient = makeAddr("recipient");
        uint256 transferAmount = 1000 * 1e6; // 1000 USDC (6 decimals)
        
        // 使用vm.prank模拟从whale地址发送交易
        uint256 whaleBalance = IERC20(USDC).balanceOf(WHALE_ADDRESS);
        console.log("Whale USDC Balance:", whaleBalance / 1e6, "USDC");
        
        if (whaleBalance >= transferAmount) {
            // 模拟whale授权给我们的合约
            vm.prank(WHALE_ADDRESS);
            IERC20(USDC).approve(address(forkTester), transferAmount);
            
            // 执行转账
            vm.prank(WHALE_ADDRESS);
            forkTester.simulateTransfer(USDC, WHALE_ADDRESS, recipient, transferAmount);
            
            // 验证转账结果
            uint256 recipientBalance = IERC20(USDC).balanceOf(recipient);
            console.log("Recipient received:", recipientBalance / 1e6, "USDC");
            
            assertEq(recipientBalance, transferAmount, "Transfer should complete successfully");
        } else {
            console.log("Whale doesn't have enough USDC for test");
        }
    }
    
    /**
     * @dev 测试时间旅行功能
     */
    function test_TimeTravel() public {
        console.log("\n=== Time Travel Test ===");
        
        uint256 originalBlock = block.number;
        uint256 originalTimestamp = block.timestamp;
        
        console.log("Original Block:", originalBlock);
        console.log("Original Timestamp:", originalTimestamp);
        
        // 前进100个区块
        vm.roll(originalBlock + 100);
        vm.warp(originalTimestamp + 100 * 12); // 假设12秒一个区块
        
        (uint256 newBlock, uint256 newTimestamp,) = forkTester.getBlockInfo();
        
        console.log("New Block:", newBlock);
        console.log("New Timestamp:", newTimestamp);
        
        assertEq(newBlock, originalBlock + 100, "Should advance 100 blocks");
        assertEq(newTimestamp, originalTimestamp + 100 * 12, "Should advance time");
    }
    
    /**
     * @dev 测试在不同区块高度Fork的功能
     */
    function test_ForkAtDifferentBlocks() public {
        console.log("\n=== Different Block Fork Test ===");
        
        // 创建一个更早的Fork
        uint256 earlierBlock = FORK_BLOCK_NUMBER - 1000;
        uint256 earlierFork = vm.createFork(
            vm.envOr("MAINNET_RPC_URL", string("https://eth-mainnet.alchemyapi.io/v2/demo")),
            earlierBlock
        );
        
        // 切换到更早的Fork
        vm.selectFork(earlierFork);
        
        console.log("Switched to earlier fork at block:", block.number);
        assertEq(block.number, earlierBlock, "Should be at earlier block");
        
        // 切换回原来的Fork
        vm.selectFork(mainnetFork);
        console.log("Switched back to main fork at block:", block.number);
        assertEq(block.number, FORK_BLOCK_NUMBER, "Should be back at original block");
    }
    
    /**
     * @dev 测试给任意地址发送ETH
     */
    function test_DealETH() public {
        console.log("\n=== Deal ETH Test ===");
        
        address testAccount = makeAddr("testAccount");
        uint256 ethAmount = 100 ether;
        
        console.log("Before deal - Balance:", testAccount.balance / 1e18, "ETH");
        
        // 使用vm.deal给地址发送ETH
        vm.deal(testAccount, ethAmount);
        
        console.log("After deal - Balance:", testAccount.balance / 1e18, "ETH");
        
        assertEq(testAccount.balance, ethAmount, "Should have correct ETH balance");
    }
    
    /**
     * @dev 测试给任意地址发送ERC20代币
     */
    function test_DealTokens() public {
        console.log("\n=== Deal Tokens Test ===");
        
        address testAccount = makeAddr("testAccount");
        uint256 usdcAmount = 10000 * 1e6; // 10,000 USDC
        
        console.log("Before deal - USDC Balance:", IERC20(USDC).balanceOf(testAccount) / 1e6, "USDC");
        
        // 使用vm.deal给地址发送代币
        deal(USDC, testAccount, usdcAmount);
        
        console.log("After deal - USDC Balance:", IERC20(USDC).balanceOf(testAccount) / 1e6, "USDC");
        
        assertEq(IERC20(USDC).balanceOf(testAccount), usdcAmount, "Should have correct USDC balance");
    }
}