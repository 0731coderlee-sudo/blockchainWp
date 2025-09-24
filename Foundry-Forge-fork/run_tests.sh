#!/bin/bash

# 测试脚本 - 运行各种Fork测试
set -e

echo "🧪 开始 Foundry Fork 测试..."

# 检查是否有 .env 文件
if [ ! -f .env ]; then
    echo "⚠️  创建默认 .env 文件..."
    cp .env.example .env
fi

echo "📋 可用的测试:"
echo "1. test_basic     - 基础Fork功能测试"
echo "2. test_balances  - 代币余额检查测试"  
echo "3. test_tx        - 交易模拟测试"
echo "4. test_time      - 时间旅行测试"
echo "5. test_all       - 运行所有测试"
echo ""

# 获取测试类型
TEST_TYPE=${1:-"all"}

case $TEST_TYPE in
    "basic")
        echo "🔍 运行基础测试..."
        forge test --match-test "test_ForkBasicInfo" -vvv
        ;;
    "balances")
        echo "💰 运行余额检查测试..."
        forge test --match-test "test_CheckRealBalances" -vvv
        ;;
    "tx")
        echo "🔄 运行交易测试..."
        forge test --match-test "test_SimulateTransactions" -vvv
        ;;
    "time")
        echo "⏰ 运行时间旅行测试..."
        forge test --match-test "test_TimeTravel" -vvv
        ;;
    "deal")
        echo "💸 运行资产分配测试..."
        forge test --match-test "test_Deal" -vvv
        ;;
    "all")
        echo "🚀 运行所有测试..."
        forge test -vvv
        ;;
    *)
        echo "❌ 未知的测试类型: $TEST_TYPE"
        echo "使用方法: ./run_tests.sh [basic|balances|tx|time|deal|all]"
        exit 1
        ;;
esac

echo "✅ 测试完成!"