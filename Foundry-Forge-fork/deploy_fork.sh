#!/bin/bash

# 部署脚本 - 部署合约到Fork网络
set -e

echo "📦 部署 ForkTester 合约到 Fork 网络..."

# 默认配置
FORK_URL="http://localhost:8545"
PRIVATE_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"

# 检查Fork网络是否运行
if ! curl -s "$FORK_URL" > /dev/null; then
    echo "❌ Fork 网络未运行，请先运行 ./start_fork.sh"
    exit 1
fi

echo "🌐 Fork 网络地址: $FORK_URL"
echo "🔑 使用默认私钥部署合约..."

# 部署合约
forge script script/Deploy.s.sol:DeployForkTester \
    --rpc-url "$FORK_URL" \
    --private-key "$PRIVATE_KEY" \
    --broadcast \
    -vvv

echo "✅ 部署完成!"
echo "📋 你可以使用以下命令与合约交互:"
echo "cast call [CONTRACT_ADDRESS] \"getBlockInfo()\" --rpc-url $FORK_URL"