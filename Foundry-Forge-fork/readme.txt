# 🍴 Foundry Fork 私有测试网络

> 使用 Foundry Forge fork 技术搭建指定区块高度的私有测试网络，完美复制主网状态进行本地开发和测试

[![Foundry](https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg)](https://getfoundry.sh/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🎯 项目概述

这个项目演示如何使用 Foundry 的 Fork 功能创建一个完全复制主网状态的本地测试环境。你可以：

- 🔄 Fork 任意区块高度的网络状态
- 💰 与真实的 DeFi 协议交互
- ⏰ 进行时间旅行测试
- 🧪 在安全环境中测试复杂的交易逻辑
- 📊 检查真实地址的余额和状态

## 📁 项目结构

```
Foundry-Forge-fork/
├── src/
│   └── ForkTester.sol          # Fork测试合约
├── test/
│   └── ForkTest.t.sol          # 全面的Fork测试套件
├── script/
│   └── Deploy.s.sol            # 部署脚本
├── foundry.toml                # Foundry配置
├── .env.example                # 环境变量模板
├── start_fork.sh               # 启动Fork网络
├── run_tests.sh                # 运行测试脚本
├── deploy_fork.sh              # 部署脚本
└── README.md                   # 项目文档
```

## 🚀 快速开始

### 1. 环境准备

```bash
# 安装 Foundry (如果还没安装)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# 克隆并进入项目目录
cd Foundry-Forge-fork

# 安装依赖
forge install
```

### 2. 配置环境

```bash
# 复制环境配置模板
cp .env.example .env

# 编辑 .env 文件，填入你的 RPC URLs
# 你可以使用 Alchemy, Infura 或其他 RPC 提供商
```

### 3. 启动 Fork 网络

```bash
# 给脚本添加执行权限
chmod +x *.sh

# 启动主网 Fork (默认区块 18500000)
./start_fork.sh

# 或指定特定网络和区块
./start_fork.sh mainnet 18600000
./start_fork.sh sepolia 4500000
```

### 4. 运行测试

```bash
# 在另一个终端运行测试
./run_tests.sh all

# 或运行特定测试
./run_tests.sh basic      # 基础功能测试
./run_tests.sh balances   # 余额检查测试
./run_tests.sh tx         # 交易模拟测试
./run_tests.sh time       # 时间旅行测试
```

## 🧪 核心功能演示

### 1. Fork 基本信息检查

```solidity
// 获取当前Fork的区块信息
(uint256 blockNumber, uint256 timestamp, bytes32 blockHash) = forkTester.getBlockInfo();
console.log("Block Number:", blockNumber);
console.log("Block Timestamp:", timestamp);
```

### 2. 真实余额查询

```solidity
// 检查 Vitalik 地址的代币余额
uint256[] memory balances = forkTester.checkMultipleBalances(VITALIK_ADDRESS);
console.log("USDC Balance:", balances[0]);
console.log("WETH Balance:", balances[1]);
console.log("DAI Balance:", balances[2]);
```

### 3. 交易模拟

```solidity
// 模拟从某个地址转账 USDC
vm.prank(WHALE_ADDRESS);
forkTester.simulateTransfer(USDC, WHALE_ADDRESS, recipient, 1000 * 1e6);
```

### 4. 时间旅行

```solidity
// 前进到未来的区块
vm.roll(block.number + 100);
vm.warp(block.timestamp + 1200); // 前进20分钟
```

### 5. 资产分配测试

```solidity
// 给任意地址分配 ETH 和代币进行测试
vm.deal(testAccount, 100 ether);
deal(USDC, testAccount, 10000 * 1e6);
```

## 📋 支持的网络

| 网络 | 标识符 | 说明 |
|------|--------|------|
| Ethereum Mainnet | `mainnet` | 以太坊主网 |
| Sepolia Testnet | `sepolia` | 以太坊测试网 |
| BSC Mainnet | `bsc` | 币安智能链 |
| Polygon Mainnet | `polygon` | Polygon主网 |

## 🛠️ 高级用法

### 自定义区块高度 Fork

```bash
# Fork 特定区块的网络状态
anvil --fork-url $RPC_URL --fork-block-number 18500000
```

### 多 Fork 环境

```solidity
// 创建多个不同区块高度的 Fork
uint256 fork1 = vm.createFork(mainnetUrl, 18500000);
uint256 fork2 = vm.createFork(mainnetUrl, 18400000);

// 在不同 Fork 之间切换
vm.selectFork(fork1);
// ... 在 fork1 上执行操作

vm.selectFork(fork2);
// ... 在 fork2 上执行操作
```

### 实时数据测试

```solidity
// 测试当前最新区块的状态
uint256 latestFork = vm.createFork(rpcUrl); // 不指定区块号 = 最新
vm.selectFork(latestFork);
```

## 🔧 配置说明

### foundry.toml 配置

```toml
# Fork 测试配置
[profile.fork]
fork_url = "${FORK_RPC_URL}"
fork_block_number = ${FORK_BLOCK_NUMBER}

# RPC 端点配置
[rpc_endpoints]
mainnet = "${MAINNET_RPC_URL}"
sepolia = "${SEPOLIA_RPC_URL}"
```

### 环境变量

```env
# RPC URLs
MAINNET_RPC_URL=https://eth-mainnet.alchemyapi.io/v2/YOUR_API_KEY
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY

# Fork 配置
FORK_BLOCK_NUMBER=18500000
FORK_RPC_URL=${MAINNET_RPC_URL}

# 测试账户私钥
PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

## 🎯 实际应用场景

### 1. DeFi 协议测试
- 测试 Uniswap 交易逻辑
- 验证借贷协议行为
- 模拟清算场景

### 2. MEV 策略验证
- 回测套利机会
- 测试 Flashloan 逻辑
- 验证 Sandwich 攻击防护

### 3. 智能合约审计
- 测试合约在真实环境中的行为
- 验证与现有协议的集成
- 检查边界条件

### 4. 历史数据分析
- 重现历史交易
- 分析特定区块的状态
- 调试过去的交易失败

## 📊 测试结果示例

运行测试后，你将看到类似这样的输出：

```
=== Fork Basic Info Test ===
Block Number: 18500000
Block Timestamp: 1698825600
Block Hash: 0x1234567890abcdef...

=== Real Balance Check Test ===
Vitalik ETH Balance: 2847 ETH
USDC Balance: 0
WETH Balance: 1.5 WETH
DAI Balance: 0 DAI

=== Transaction Simulation Test ===
Whale USDC Balance: 50000000 USDC
Recipient received: 1000 USDC
✅ Transfer completed successfully
```

## 🚨 注意事项

1. **RPC 限制**: 免费的 RPC 服务通常有请求限制
2. **区块数据**: 太老的区块可能无法访问
3. **内存使用**: Fork 会消耗较多内存
4. **网络延迟**: Fork 速度取决于 RPC 响应时间

## 🤝 贡献指南

欢迎提交 Issues 和 Pull Requests！

1. Fork 本仓库
2. 创建功能分支: `git checkout -b feature/new-feature`
3. 提交更改: `git commit -am 'Add new feature'`
4. 推送到分支: `git push origin feature/new-feature`
5. 提交 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](../LICENSE) 文件了解详情。

---

⭐ 如果这个项目对你有帮助，请给个 star 支持一下！

**最后更新**: 2025-09-25