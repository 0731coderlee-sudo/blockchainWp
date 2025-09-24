# Foundry Fork + Ethernal 区块浏览器

🚀 一个完整的以太坊本地开发环境，集成了 Foundry 工具链和 Ethernal 区块浏览器。

## 📋 项目简介

本项目提供了两种启动方式：
- **纯 Fork 网络**：轻量级的 Anvil fork 环境
- **Fork + 浏览器**：集成 Ethernal 可视化界面的完整开发环境

## 🎯 Ethernal 工作原理说明

### ⚠️ 重要澄清

**Ethernal 不是传统的区块链浏览器！**

- ❌ **不会显示** 以太坊主网的历史数据
- ❌ **不会显示** Vitalik 等地址在主网的交易记录
- ❌ **不会显示** 主网上的 DeFi 协议活动
- ✅ **只显示** 你本地 Anvil 网络的新活动
- ✅ **只显示** 你部署的合约和发送的交易
- ✅ **只显示** 从启动 Ethernal 之后的操作

### 🏗️ 架构原理

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│   Anvil Fork    │───▶│  Ethernal CLI    │───▶│ Ethernal Dashboard  │
│  (本地网络)      │    │  (数据收集器)     │    │   (Web 界面)        │
│                 │    │                  │    │                     │
│ - Fork 主网状态  │    │ - 监听本地 RPC   │    │ - 显示本地活动      │
│ - 可查询历史     │    │ - 收集新交易     │    │ - 只显示新操作      │
│ - 支持 cast 查询│    │ - 同步到云端     │    │ - 合约交互界面      │
└─────────────────┘    └──────────────────┘    └─────────────────────┘
```

### 📊 实际使用场景

**适合 Ethernal：**
- 🔧 查看你部署的合约状态
- 📈 监控你的测试交易
- 🕵️ 调试合约交互过程
- 👥 团队共享开发环境状态

**需要用 cast 命令：**
- 🔍 查询 Fork 状态下的历史余额
- 📊 调用主网合约的历史状态
- 💰 查看知名地址的 ETH/代币余额

**查看真实主网数据：**
- 🌐 使用 [Etherscan](https://etherscan.io)
- 🔍 使用其他主网区块浏览器

## 🚀 快速开始

### 1. 环境准备

```bash
# 安装 Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# 安装 Ethernal
npm install -g ethernal

# 克隆项目
git clone <your-repo-url>
cd Foundry-Forge-fork
```

### 2. 配置环境变量

```bash
# 编辑配置文件
vim .env
```

**必填配置：**
```bash
# RPC 配置 (推荐使用 Alchemy)
MAINNET_RPC_URL=https://eth-mainnet.g.alchemy.com/v2/YOUR_API_KEY

# Fork 区块配置
FORK_BLOCK_NUMBER=18500000  # 或使用 latest

# Ethernal 登录信息 (在 app.tryethernal.com 注册)
ETHERNAL_EMAIL=your@email.com
ETHERNAL_PASSWORD=yourpassword
```

### 3. 启动服务

#### 方式 1：纯 Fork 网络（推荐用于性能测试）

```bash
./start_fork.sh
# 或指定参数
./start_fork.sh mainnet 19000000 8545
```

#### 方式 2：Fork + Ethernal 浏览器（推荐用于开发调试）

```bash
./start_ethernal.sh
```

### 4. 测试网络

```bash
# 测试基本连接
./test_fork.sh

# 手动查询余额（查询 Fork 状态下的历史数据）
cast balance 0xd8da6bf26964af9d7eed9e03e53415d37aa96045 --rpc-url http://localhost:8545

# 部署测试合约
forge script script/Counter.s.sol:CounterScript --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
```

### 5. 查看结果

- **命令行查询**：使用 `cast` 命令查询任何地址/合约状态
- **Ethernal 界面**：访问 [https://app.tryethernal.com/](https://app.tryethernal.com/) 查看你的本地活动

## 📁 项目结构

```
├── .env                 # 环境变量配置
├── start_fork.sh        # 纯 Anvil fork 启动脚本
├── start_ethernal.sh    # Anvil + Ethernal 启动脚本
├── stop_ethernal.sh     # 停止所有服务
├── test_fork.sh         # 网络测试脚本
├── script/
│   ├── Counter.s.sol    # 示例部署脚本
│   └── Deploy.s.sol     # 部署脚本
├── src/
│   ├── Counter.sol      # 示例合约
│   └── ForkTester.sol   # Fork 测试合约
└── test/
    ├── Counter.t.sol    # 合约测试
    └── ForkTest.t.sol   # Fork 测试
```

## 🔧 统一配置

两个启动脚本使用**完全相同的 Anvil 参数**：

```bash
anvil \
    --fork-url "$RPC_URL" \
    --fork-block-number "$BLOCK_NUMBER" \
    --port 8545 \
    --host 0.0.0.0 \
    --accounts 10 \
    --balance 10000 \
    --gas-limit 300000000 \
    --code-size-limit 50000 \
    --base-fee 0 \
    --gas-price 0
```

## 📊 测试账户

默认提供 10 个测试账户，每个账户有 10000 ETH：

```
Account #0: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
Account #1: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
Account #2: 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
...

Private Key #0: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

## 🎯 使用技巧

### 查询历史状态

```bash
# 查询知名地址余额（Fork 时的状态）
cast balance 0xd8da6bf26964af9d7eed9e03e53415d37aa96045 --rpc-url http://localhost:8545

# 查询 USDC 余额
cast call 0xA0b86a33E6417c752e2c4494b79E3e48Cd90f263 "balanceOf(address)" 0xd8da6bf26964af9d7eed9e03e53415d37aa96045 --rpc-url http://localhost:8545

# 调用任何主网合约
cast call 0xContract_Address "functionName()" --rpc-url http://localhost:8545
```

### 发送测试交易

```bash
# 转账 ETH
cast send --value 1ether 0xRecipient_Address --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --rpc-url http://localhost:8545

# 调用合约函数
cast send 0xContract_Address "functionName()" --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --rpc-url http://localhost:8545
```

## 🛑 停止服务

```bash
# 停止所有服务
./stop_ethernal.sh

# 或手动停止
pkill -f anvil
pkill -f ethernal
```

## ❓ 常见问题

### Q: 为什么 Ethernal 显示不了 Vitalik 的交易？
A: Ethernal 只显示本地网络的**新活动**，不会显示 Fork 时的历史数据。要查询历史状态请使用 `cast` 命令。

### Q: 如何查看主网的实时数据？
A: 请使用 [Etherscan](https://etherscan.io) 等主网区块浏览器。

### Q: 为什么需要注册 Ethernal 账号？
A: Ethernal 使用云端 Dashboard 提供 Web 界面，本地 CLI 只是数据收集器。

### Q: 如何更改 Fork 的区块高度？
A: 修改 `.env` 文件中的 `FORK_BLOCK_NUMBER` 值，然后重启服务。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

---

**注意**：本项目仅用于开发和测试目的，请勿在生产环境中使用。
