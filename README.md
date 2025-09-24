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
| [FakePow](#fakepow---工作量证明实现) | 自定义工作量证明(PoW)算法实现 | Python, RSA加密 | ✅ 完成 | 2025-09 |
| [SepoliaContract](#sepoliacontract---智能合约) | 简单的以太坊智能合约示例 ([合约地址](https://sepolia.etherscan.io/address/0x852736cb75de0fa680d5d5de14056dfc993c7f66)) | Solidity | ✅ 已部署 | 2025-09 |
| [BuyMeACoffee](#buymeacoffee---foundry项目) | 使用Foundry框架的智能合约项目 ([合约地址](https://virtual.mainnet.eu.rpc.tenderly.co/2beac3f2-1d29-419a-af9b-c3639e77edc6)) | Solidity, Foundry | ✅ 已部署 | 2025-09 |

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

### BuyMeACoffee - Foundry项目

现代化的Solidity智能合约开发项目，使用Foundry工具链：

**技术特性**：
- Foundry框架 (forge, cast, anvil)
- 现代化Solidity开发工作流
- 自动化测试和部署
- 基础的计数器合约功能

**项目结构**：
```
tenderly/BuyMeACoffee/
├── src/
│   ├── BuyMeACoffee.sol    # 主合约文件
│   └── Counter.sol         # 示例计数器合约
├── test/                   # 测试文件
├── script/                 # 部署脚本  
├── foundry.toml           # Foundry配置
└── deployment.md          # 部署记录
```

**部署信息**：
- 网络: Tenderly Virtual Mainnet
- 合约地址: [`0xE72B348bCA4DAAD3d8886342557d581B50Bf3971`](https://dashboard.tenderly.co/contract/16888/0xE72B348bCA4DAAD3d8886342557d581B50Bf3971)
- 部署交易: `0xcd287505af810e175ca9713ce1a93f8ccfa6fe6de8532826d3d37971712a0aed`
- 部署账户: `0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266`
- 状态: ✅ 已部署并测试
- 工具: Foundry forge + cast

## 🤖 自动化更新

本项目使用 **GitHub Actions** 自动维护README信息：

- ✅ **自动更新时间戳**: 基于git提交记录更新各项目的最后修改时间
- ✅ **智能状态检测**: 自动识别项目完成状态和部署情况  
- ✅ **零维护成本**: 每次push后自动运行，无需手动操作

> 💡 **工作原理**: 每当你push代码到main分支时，GitHub Actions会自动扫描各项目文件夹，获取最新的git提交时间并更新到README表格中。

## �🤝 贡献指南

欢迎对这个学习项目提出建议和改进！

1. Fork 本仓库
2. 创建你的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开一个 Pull Request


## 📬 联系方式

- GitHub: [@0731coderlee-sudo](https://github.com/0731coderlee-sudo)
- 邮箱: 如有技术讨论，欢迎提issue

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

---

⭐ 如果这个项目对你的Web3学习有帮助，请给个star支持一下！

**最后更新: 2025-09 🚀**