# 🌐 Web3 Learning Journey

> 记录我的Web3学习过程中的实操项目和代码实践

[![GitHub Stars](https://img.shields.io/github/stars/0731coderlee-sudo/blockchainWp?style=social)](https://github.com/0731coderlee-sudo/blockchainWp)
[![GitHub Forks](https://img.shields.io/github/forks/0731coderlee-sudo/blockchainWp?style=social)](https://github.com/0731coderlee-sudo/blockchainWp)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## 📋 目录

- [项目概述](#-项目概述)
- [项目列表](#-项目列表)
- [技术栈](#-技术栈)
- [快速开始](#-快速开始)
- [学习路径](#-学习路径)
- [贡献指南](#-贡献指南)
- [联系方式](#-联系方式)

## 🎯 项目概述

这个仓库记录了我在Web3领域的学习历程，包含从基础概念到实际应用的各种项目。每个项目都包含完整的代码实现、详细的注释和学习笔记。

## 📁 项目列表

### 🔥 已完成项目

| 项目名称 | 描述 | 技术栈 | 状态 | 更新时间 |
|---------|------|--------|------|----------|
| [FakePow](#fakepow---工作量证明实现) | 自定义工作量证明(PoW)算法实现 | Python, RSA加密 | ✅ 完成 | 2024-09 |
| [SepoliaContract](#sepoliacontract---智能合约) | 简单的以太坊智能合约示例 ([合约地址](https://sepolia.etherscan.io/address/0x852736cb75de0fa680d5d5de14056dfc993c7f66)) | Solidity | ✅ 已部署 | 2024-09 |

### 🚧 计划中项目

- [ ] DeFi协议交互
- [ ] NFT市场开发
- [ ] DAO治理机制
- [ ] Layer2解决方案
- [ ] Web3前端应用

## 🛠 技术栈

### 区块链技术
- **智能合约**: Solidity, Hardhat
- **区块链网络**: Ethereum, Sepolia测试网
- **开发工具**: Remix, MetaMask

### 编程语言
- **Python**: 核心算法实现
- **JavaScript/TypeScript**: 前端交互
- **Solidity**: 智能合约开发

### 密码学
- **加密算法**: RSA, SHA-256
- **数字签名**: ECDSA
- **哈希函数**: Keccak-256

## 🚀 快速开始

### 环境准备

```bash
# 克隆仓库
git clone https://github.com/0731coderlee-sudo/blockchainWp.git
cd blockchainWp

# Python环境（用于PoW项目）
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 运行项目

#### FakePow - 工作量证明实现
```bash
cd fakePow
python Pow.py          # 运行PoW算法
python verifyedPow.py  # 验证PoW结果
```

#### SepoliaContract - 智能合约
```bash
cd firstContract
# 使用Remix IDE部署到Sepolia测试网
# 合约地址将在部署后更新
```

## 📚 学习路径

### 🎓 阶段一：基础理论
- [x] 区块链基本概念
- [x] 密码学基础
- [x] 共识机制（PoW, PoS）
- [x] 数字签名和哈希函数

### 🔧 阶段二：技术实践
- [x] 自实现PoW算法
- [x] 智能合约开发基础
- [ ] DApp前端开发
- [ ] Web3.js/Ethers.js使用

### 🚀 阶段三：项目实战
- [ ] DeFi协议开发
- [ ] NFT项目
- [ ] 跨链技术
- [ ] Layer2解决方案

## 📖 项目详情

### FakePow - 工作量证明实现

一个简化的工作量证明算法实现，包含：

**核心功能**：
- RSA密钥对生成
- 数字签名验证
- 挖矿难度调整
- 工作量证明验证

**文件结构**：
```
fakePow/
├── Pow.py              # 主要PoW算法实现
├── verifyedPow.py      # 验证算法
├── public_key.pem      # RSA公钥
├── rs.txt              # 签名结果1
└── rs2.txt             # 签名结果2

firstContract/
├── sepoliaConter.sol   # Solidity智能合约
└── rs.txt              # 部署记录（交易哈希和合约地址）
```

### SepoliaContract - 智能合约

基础的Solidity智能合约示例：

**功能特性**：
- 简单的状态管理
- 基础的访问控制
- 事件日志记录

**部署信息**：
- 网络: Sepolia测试网
- 合约地址: [`0x852736cb75de0fa680d5d5de14056dfc993c7f66`](https://sepolia.etherscan.io/address/0x852736cb75de0fa680d5d5de14056dfc993c7f66)
- 部署交易: [`0x12f7e03f7a90e4eb93fc82427a527a36e6bc0de32a519bae037baa40d6952635`](https://sepolia.etherscan.io/tx/0x12f7e03f7a90e4eb93fc82427a527a36e6bc0de32a519bae037baa40d6952635)

## 🤝 贡献指南

欢迎对这个学习项目提出建议和改进！

1. Fork 本仓库
2. 创建你的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开一个 Pull Request

## 📝 学习笔记

每个项目文件夹中都包含详细的学习笔记和技术文档，记录了：
- 实现思路和设计决策
- 遇到的问题和解决方案
- 学习心得和技术总结
- 参考资料和延伸阅读

## 📬 联系方式

- GitHub: [@0731coderlee-sudo](https://github.com/0731coderlee-sudo)
- 邮箱: 如有技术讨论，欢迎提issue

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

---

⭐ 如果这个项目对你的Web3学习有帮助，请给个star支持一下！

**持续更新中... 🚀**