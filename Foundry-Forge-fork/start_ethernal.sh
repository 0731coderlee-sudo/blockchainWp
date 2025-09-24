#!/bin/bash

# 🚀 Foundry + Ethernal 区块浏览器启动脚本
# 作者: GitHub Copilot
# 功能: 启动 Anvil fork 网络 + Ethernal 区块浏览器

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 配置
FORK_URL=""
PORT=8545
ETHERNAL_EMAIL=""
ETHERNAL_PASSWORD=""

# 公共 RPC 端点备选
PUBLIC_RPC_URLS=(
    "https://ethereum.publicnode.com"
    "https://rpc.ankr.com/eth" 
    "https://eth.drpc.org"
    "https://ethereum-rpc.publicnode.com"
)

echo -e "${CYAN}🚀 启动 Foundry + Ethernal 集成环境${NC}"
echo "============================================="

# 检查环境变量
if [ -f .env ]; then
    source .env
    echo -e "${GREEN}✅ 加载 .env 配置文件${NC}"
fi

# 选择 Fork RPC URL
select_rpc_url() {
    echo -e "${YELLOW}🔍 检测可用的 RPC 端点...${NC}"
    
    # 首先尝试使用 .env 中的 RPC
    if [ -n "$MAINNET_RPC_URL" ]; then
        echo -e "${BLUE}🧪 测试配置的 RPC: $MAINNET_RPC_URL${NC}"
        if curl -s -X POST -H "Content-Type: application/json" \
            --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
            "$MAINNET_RPC_URL" | grep -q "result"; then
            FORK_URL="$MAINNET_RPC_URL"
            echo -e "${GREEN}✅ 使用配置的 RPC${NC}"
            return 0
        else
            echo -e "${YELLOW}⚠️  配置的 RPC 不可用，尝试公共端点${NC}"
        fi
    fi
    
    # 尝试公共 RPC 端点
    for rpc_url in "${PUBLIC_RPC_URLS[@]}"; do
        echo -e "${BLUE}🧪 测试: $rpc_url${NC}"
        if curl -s -X POST -H "Content-Type: application/json" \
            --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
            "$rpc_url" | grep -q "result"; then
            FORK_URL="$rpc_url"
            echo -e "${GREEN}✅ 选择: $rpc_url${NC}"
            return 0
        fi
    done
    
    echo -e "${RED}❌ 没有找到可用的 RPC 端点!${NC}"
    exit 1
}

# 选择 RPC URL
select_rpc_url

# 检查 Ethernal 登录凭据
if [ -z "$ETHERNAL_EMAIL" ] || [ -z "$ETHERNAL_PASSWORD" ]; then
    echo -e "${YELLOW}⚠️  请设置 Ethernal 登录凭据${NC}"
    echo "请在 .env 文件中添加："
    echo "ETHERNAL_EMAIL=your@email.com"
    echo "ETHERNAL_PASSWORD=yourpassword"
    echo ""
    echo "或者现在手动输入（推荐在 .env 中配置）："
    
    if [ -z "$ETHERNAL_EMAIL" ]; then
        read -p "Ethernal Email: " ETHERNAL_EMAIL
    fi
    
    if [ -z "$ETHERNAL_PASSWORD" ]; then
        read -s -p "Ethernal Password: " ETHERNAL_PASSWORD
        echo
    fi
fi

# 停止之前可能运行的进程
echo -e "${YELLOW}🔄 清理之前的进程...${NC}"
pkill -f "anvil" || true
pkill -f "ethernal" || true

# 启动 Anvil
if [ -n "$FORK_BLOCK_NUMBER" ] && [ "$FORK_BLOCK_NUMBER" != "latest" ]; then
    echo -e "${BLUE}⛽ 启动 Anvil 网络 (Fork: Mainnet - 区块: $FORK_BLOCK_NUMBER)${NC}"
    echo -e "${YELLOW}🔗 Fork 区块高度: $FORK_BLOCK_NUMBER${NC}"
    anvil \
        --fork-url "$FORK_URL" \
        --fork-block-number "$FORK_BLOCK_NUMBER" \
        --port "$PORT" \
        --host 0.0.0.0 \
        --accounts 10 \
        --balance 10000 \
        --gas-limit 300000000 \
        --code-size-limit 50000 \
        --base-fee 0 \
        --gas-price 0 &
else
    echo -e "${BLUE}⛽ 启动 Anvil 网络 (Fork: Mainnet - 最新区块)${NC}"
    echo -e "${YELLOW}🔗 Fork 最新区块${NC}"
    anvil \
        --fork-url "$FORK_URL" \
        --port "$PORT" \
        --host 0.0.0.0 \
        --accounts 10 \
        --balance 10000 \
        --gas-limit 300000000 \
        --code-size-limit 50000 \
        --base-fee 0 \
        --gas-price 0 &
fi
ANVIL_PID=$!

# 等待 Anvil 启动
echo -e "${YELLOW}⏳ 等待 Anvil 启动...${NC}"
sleep 3

# 验证 Anvil 是否启动成功
if ! curl -s -X POST -H "Content-Type: application/json" \
    --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
    http://localhost:$PORT > /dev/null; then
    echo -e "${RED}❌ Anvil 启动失败!${NC}"
    kill $ANVIL_PID 2>/dev/null || true
    exit 1
fi

echo -e "${GREEN}✅ Anvil 启动成功! (PID: $ANVIL_PID)${NC}"
echo "   - RPC Endpoint: http://localhost:$PORT"
echo "   - Chain ID: 31337"
echo "   - Fork: Ethereum Mainnet"
echo "   - 账户数量: 10 (各有 10000 ETH)"
echo "   - Gas Limit: 300,000,000"
echo "   - Base Fee: 0 (免费交易)"

# 显示默认账户
echo -e "${PURPLE}👥 默认账户 (各有 10000 ETH):${NC}"
echo "Account #0: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
echo "Account #1: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
echo "Account #2: 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC"

# 启动 Ethernal
echo -e "${CYAN}🔍 启动 Ethernal 区块浏览器...${NC}"

# 设置环境变量并启动 Ethernal
export ETHERNAL_EMAIL="$ETHERNAL_EMAIL"
export ETHERNAL_PASSWORD="$ETHERNAL_PASSWORD"

# 启动 Ethernal 监听
ethernal listen &
ETHERNAL_PID=$!

echo -e "${GREEN}✅ Ethernal 启动成功! (PID: $ETHERNAL_PID)${NC}"

# 等待用户操作
echo ""
echo -e "${GREEN}🎉 环境启动完成!${NC}"
echo "============================================="
echo -e "${CYAN}📱 Ethernal Dashboard: ${NC}https://app.tryethernal.com/"
echo -e "${BLUE}🔧 RPC Endpoint: ${NC}http://localhost:$PORT"
echo -e "${YELLOW}⛓️  Chain ID: ${NC}31337"
echo ""
echo -e "${PURPLE}💡 使用提示:${NC}"
echo "1. 访问 https://app.tryethernal.com/ 查看区块浏览器"
echo "2. 部署合约或发送交易会自动显示在浏览器中"
echo "3. 按 Ctrl+C 停止所有服务"
echo ""

# 创建停止函数
cleanup() {
    echo ""
    echo -e "${YELLOW}🛑 正在停止服务...${NC}"
    kill $ANVIL_PID 2>/dev/null || true
    kill $ETHERNAL_PID 2>/dev/null || true
    pkill -f "anvil" || true
    pkill -f "ethernal" || true
    echo -e "${GREEN}✅ 所有服务已停止${NC}"
    exit 0
}

# 捕获中断信号
trap cleanup SIGINT SIGTERM

# 保持脚本运行
echo -e "${BLUE}🏃 服务运行中... (按 Ctrl+C 停止)${NC}"
wait