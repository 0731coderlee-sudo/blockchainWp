# BuyMeACoffee 合约部署记录

## 项目信息
- **合约名称**: BuyMeACoffee
- **编译器版本**: Solidity ^0.8.13
- **部署网络**: Tenderly Virtual Mainnet
- **部署工具**: Foundry (forge)

## 部署尝试记录

### 尝试 1 - 2025-09-25
- **网络URL**: https://virtual.mainnet.eu.rpc.tenderly.co/2beac3f2-1d29-419a-af9b-c3639e77edc6
- **部署账户**: 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
- **状态**: ❌ 失败 - 账户余额不足
- **错误**: insufficient funds for gas * price + value
- **账户余额**: 0 ETH

### 解决方案
需要在Tenderly控制台中为部署账户充值ETH，然后重新尝试部署。

## 合约ABI
```json
[
  {
    "type": "function",
    "name": "add",
    "inputs": [
      {
        "name": "x",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "get",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  }
]
```

## 待部署
一旦账户有足够的ETH余额，使用以下命令部署：

```bash
forge create src/BuyMeACoffee.sol:BuyMeACoffee \
--rpc-url https://virtual.mainnet.eu.rpc.tenderly.co/2beac3f2-1d29-419a-af9b-c3639e77edc6 \
--private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
--broadcast
```