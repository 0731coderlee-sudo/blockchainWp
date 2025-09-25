#!/bin/bash

# 成功的 Anvil 测试环境脚本
echo "🚀 启动 Anvil 本地以太坊节点..."

# 停止可能存在的容器
docker stop local-anvil 2>/dev/null || true
docker rm local-anvil 2>/dev/null || true

# 启动 Anvil - 关键：使用环境变量 ANVIL_IP_ADDR=0.0.0.0
echo "🔄 启动容器..."
docker run -d \
  --name local-anvil \
  --platform linux/amd64 \
  -p 8545:8545 \
  -e ANVIL_IP_ADDR=0.0.0.0 \
  ghcr.io/foundry-rs/foundry:latest \
  anvil --port 8545 --accounts 10 --balance 10000 --chain-id 31337

# 等待启动
echo "⏳ 等待 Anvil 启动..."
sleep 5

# 测试连接
echo "🧪 测试 RPC 连接..."
if block_number=$(cast block-number --rpc-url http://localhost:8545 2>/dev/null); then
    echo "✅ Anvil 启动成功!"
    echo "🔗 RPC URL: http://localhost:8545"
    echo "📊 Chain ID: 31337"
    echo "📦 当前区块: $block_number"
    
    # 获取账户信息
    echo "💰 可用账户:"
    accounts=$(cast rpc eth_accounts --rpc-url http://localhost:8545 2>/dev/null)
    first_account=$(echo "$accounts" | jq -r '.[0]' 2>/dev/null)
    if [ "$first_account" != "null" ] && [ -n "$first_account" ]; then
        balance=$(cast balance "$first_account" --rpc-url http://localhost:8545 2>/dev/null)
        balance_eth=$((balance / 10**18))
        echo "  账户 1: $first_account (余额: ${balance_eth} ETH)"
    fi
    
    echo ""
    echo "💡 测试命令:"
    echo "  cast block-number --rpc-url http://localhost:8545"
    echo "  cast balance $first_account --rpc-url http://localhost:8545"
    echo ""
    echo "🛑 停止环境: docker stop local-anvil"
else
    echo "❌ Anvil 启动失败"
    echo "📋 容器日志:"
    docker logs local-anvil
fi