#!/bin/bash

# Foundry Fork 网络启动脚本
# 使用方法: ./start_fork.sh [NETWORK] [BLOCK_NUMBER]

set -e

# 默认配置
DEFAULT_NETWORK="mainnet"
DEFAULT_BLOCK="18500000"  # 与 .env 保持一致
DEFAULT_PORT="8545"

# 加载环境变量 (如果存在)
if [ -f .env ]; then
    source .env
fi

# 获取参数，优先使用 .env 中的配置
NETWORK=${1:-$DEFAULT_NETWORK}
BLOCK_NUMBER=${2:-${FORK_BLOCK_NUMBER:-$DEFAULT_BLOCK}}
PORT=${3:-$DEFAULT_PORT}

echo "🚀 启动 Foundry Fork 网络..."
echo "📊 网络: $NETWORK"
echo "🔢 区块高度: $BLOCK_NUMBER"
echo "🔌 端口: $PORT"

# 检查 .env 文件 (环境变量已在上面加载)
if [ ! -f .env ]; then
    echo "⚠️  未找到 .env 文件，使用默认配置"
fi

# 根据网络选择RPC URL
case $NETWORK in
    "mainnet")
        RPC_URL=$MAINNET_RPC_URL
        ;;
    "sepolia")
        RPC_URL=$SEPOLIA_RPC_URL
        ;;
    "bsc")
        RPC_URL=$BSC_MAINNET_RPC_URL
        ;;
    "polygon")
        RPC_URL=$POLYGON_MAINNET_RPC_URL
        ;;
    *)
        echo "❌ 不支持的网络: $NETWORK"
        echo "支持的网络: mainnet, sepolia, bsc, polygon"
        exit 1
        ;;
esac

# 检查RPC URL
if [ -z "$RPC_URL" ] || [ "$RPC_URL" = "YOUR_API_KEY" ]; then
    echo "❌ 请在 .env 文件中配置正确的 RPC URL"
    exit 1
fi

echo "🌐 RPC URL: $RPC_URL"
echo "⏳ 启动中..."

# 启动 anvil fork
anvil \
    --fork-url "$RPC_URL" \
    --fork-block-number "$BLOCK_NUMBER" \
    --port "$PORT" \
    --host 0.0.0.0 \
    --accounts 10 \
    --balance 10000 \
    --gas-limit 300000000 \
    --code-size-limit 50000 \
    --base-fee 0 \
    --gas-price 0

echo "✅ Fork 网络已启动!"
echo "🔗 连接地址: http://localhost:$PORT"
echo "🏁 要停止网络，请按 Ctrl+C"