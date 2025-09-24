# BuyMeACoffee 合约部署记录

## 项目信息
- **合约名称**: BuyMeACoffee
- **编译器版本**: Solidity ^0.8.13
- **部署网络**: Tenderly Virtual Mainnet
- **部署工具**: Foundry (forge)

## 部署尝试记录

### 尝试 1 - 2025-09-25 00:00
- **网络URL**: https://virtual.mainnet.eu.rpc.tenderly.co/2beac3f2-1d29-419a-af9b-c3639e77edc6
- **部署账户**: 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
- **状态**: ❌ 失败 - 账户余额不足
- **错误**: insufficient funds for gas * price + value
- **账户余额**: 0 ETH

### 尝试 2 - 2025-09-25 01:18 ✅ 成功部署
- **充值方法**: 使用 `cast rpc tenderly_setBalance` 充值 10 ETH
- **充值交易**: 0xf161181fea2035427d8de7a0fb54dd2028f74940702b9d5ddb9e23b530306872
- **部署账户**: 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
- **合约地址**: 0xE72B348bCA4DAAD3d8886342557d581B50Bf3971
- **部署交易**: 0xcd287505af810e175ca9713ce1a93f8ccfa6fe6de8532826d3d37971712a0aed
- **状态**: ✅ 部署成功

### 充值命令记录
```bash
# 给账户充值10 ETH
cast rpc tenderly_setBalance 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266 0x8AC7230489E80000 --rpc-url https://virtual.mainnet.eu.rpc.tenderly.co/2beac3f2-1d29-419a-af9b-c3639e77edc6
```

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