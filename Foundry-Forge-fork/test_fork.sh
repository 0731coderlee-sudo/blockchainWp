#!/bin/bash

# 🧪 Fork 测试脚本
# 在服务运行时测试各种功能

echo "🧪 开始测试 Fork 网络状态..."
echo "================================="

RPC_URL="http://localhost:8545"

echo "📡 检查网络连接..."
if ! curl -s -X POST -H "Content-Type: application/json" \
    --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
    $RPC_URL > /dev/null; then
    echo "❌ 网络未连接！请先启动 ./start_ethernal.sh"
    exit 1
fi

echo "✅ 网络连接正常"

echo ""
echo "🔍 测试 1: Vitalik 地址余额"
echo "地址: 0xd8da6bf26964af9d7eed9e03e53415d37aa96045"
VITALIK_BALANCE=$(cast balance 0xd8da6bf26964af9d7eed9e03e53415d37aa96045 --rpc-url $RPC_URL)
echo "余额: $VITALIK_BALANCE wei"
echo "余额: $(cast --to-unit $VITALIK_BALANCE ether) ETH"

echo ""
echo "🪙 测试 2: USDC 代币余额"
echo "USDC 合约: 0xA0b86a33E6417c752e2c4494b79E3e48Cd90f263"
USDC_BALANCE=$(cast call 0xA0b86a33E6417c752e2c4494b79E3e48Cd90f263 "balanceOf(address)" 0xd8da6bf26964af9d7eed9e03e53415d37aa96045 --rpc-url $RPC_URL)
echo "USDC 余额: $USDC_BALANCE (raw)"

echo ""
echo "🪙 测试 3: USDT 代币余额"
echo "USDT 合约: 0xdAC17F958D2ee523a2206206994597C13D831ec7"
USDT_BALANCE=$(cast call 0xdAC17F958D2ee523a2206206994597C13D831ec7 "balanceOf(address)" 0xd8da6bf26964af9d7eed9e03e53415d37aa96045 --rpc-url $RPC_URL)
echo "USDT 余额: $USDT_BALANCE (raw)"

echo ""
echo "🔗 测试 4: 当前区块信息"
BLOCK_NUMBER=$(cast block-number --rpc-url $RPC_URL)
echo "当前区块高度: $BLOCK_NUMBER"

echo ""
echo "🎯 测试完成！现在你可以看到真实的链上状态了！"