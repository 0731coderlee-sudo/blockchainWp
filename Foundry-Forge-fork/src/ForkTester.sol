// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/interfaces/IERC20.sol";

/**
 * @title ForkTester
 * @dev 用于测试Fork功能的合约 - 与真实主网代币交互
 */
contract ForkTester {
    // 主网上的一些知名代币地址  
    address public constant USDC = 0xa0B86A33e6441C0cB13F6435b9cA20d0D2c3cc90; // USDC on Mainnet (Circle)
    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // Wrapped Ether
    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;  // DAI Stablecoin
    
    // Uniswap V2 Router (用于交易测试)
    address public constant UNISWAP_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    
    // 事件
    event TokenBalanceChecked(address token, address user, uint256 balance);
    event TokenTransferred(address token, address from, address to, uint256 amount);
    
    /**
     * @dev 检查指定地址的代币余额
     */
    function checkTokenBalance(address token, address user) external returns (uint256) {
        IERC20 tokenContract = IERC20(token);
        uint256 balance = tokenContract.balanceOf(user);
        
        emit TokenBalanceChecked(token, user, balance);
        return balance;
    }
    
    /**
     * @dev 检查多个代币的余额
     */
    function checkMultipleBalances(address user) external returns (uint256[] memory) {
        address[] memory tokens = new address[](2);
        tokens[0] = WETH;
        tokens[1] = DAI;
        
        uint256[] memory balances = new uint256[](2);
        
        for (uint i = 0; i < tokens.length; i++) {
            balances[i] = IERC20(tokens[i]).balanceOf(user);
            emit TokenBalanceChecked(tokens[i], user, balances[i]);
        }
        
        return balances;
    }
    
    /**
     * @dev 模拟代币转账 (需要有足够的余额和授权)
     */
    function simulateTransfer(
        address token,
        address from,
        address to,
        uint256 amount
    ) external {
        IERC20 tokenContract = IERC20(token);
        
        // 检查余额
        require(tokenContract.balanceOf(from) >= amount, "Insufficient balance");
        
        // 检查授权 (如果from不是msg.sender)
        if (from != msg.sender) {
            require(
                tokenContract.allowance(from, address(this)) >= amount,
                "Insufficient allowance"
            );
        }
        
        // 执行转账
        if (from == msg.sender) {
            require(tokenContract.transfer(to, amount), "Transfer failed");
        } else {
            require(tokenContract.transferFrom(from, to, amount), "TransferFrom failed");
        }
        
        emit TokenTransferred(token, from, to, amount);
    }
    
    /**
     * @dev 获取合约在指定区块的状态
     */
    function getBlockInfo() external view returns (
        uint256 blockNumber,
        uint256 timestamp,
        bytes32 blockHash
    ) {
        return (
            block.number,
            block.timestamp,
            blockhash(block.number - 1)
        );
    }
    
    /**
     * @dev 检查是否在Fork环境中
     */
    function isForkedNetwork() external view returns (bool) {
        // 在Fork环境中，我们可以访问历史区块数据
        // 这里简单检查是否能访问较旧的区块哈希
        return blockhash(block.number - 100) != bytes32(0);
    }
}