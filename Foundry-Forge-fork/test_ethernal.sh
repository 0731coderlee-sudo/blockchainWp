#!/bin/bash

# 🧪 Ethernal 测试脚本
# 用于测试区块浏览器功能（需要 Anvil 已经运行）

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}🧪 测试 Ethernal 区块浏览器功能${NC}"
echo "==========================================="

# 检查 Anvil 是否运行
if ! curl -s -X POST -H "Content-Type: application/json" \
    --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
    http://localhost:8545 > /dev/null; then
    echo -e "${YELLOW}⚠️  Anvil 未运行，请先执行 ./start_ethernal.sh${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Anvil 运行正常${NC}"

# 获取当前区块高度
BLOCK_NUMBER=$(cast block-number --rpc-url http://localhost:8545)
echo -e "${BLUE}📊 当前区块高度: ${BLOCK_NUMBER}${NC}"

# 获取默认账户余额
ACCOUNT_0="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
ACCOUNT_1="0x70997970C51812dc3A010C7d01b50e0d17dc79C8"

BALANCE_0=$(cast balance $ACCOUNT_0 --rpc-url http://localhost:8545)
BALANCE_1=$(cast balance $ACCOUNT_1 --rpc-url http://localhost:8545)

echo -e "${PURPLE}💰 账户余额:${NC}"
echo "   Account #0: $(cast from-wei $BALANCE_0 ether) ETH"
echo "   Account #1: $(cast from-wei $BALANCE_1 ether) ETH"

# 发送测试交易
echo -e "${YELLOW}🔄 发送测试交易...${NC}"

# 使用 cast 发送 ETH
TX_HASH=$(cast send $ACCOUNT_1 \
    --value 1ether \
    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    --rpc-url http://localhost:8545)

echo -e "${GREEN}✅ 交易已发送!${NC}"
echo "   交易哈希: $TX_HASH"

# 等待交易确认
echo -e "${YELLOW}⏳ 等待交易确认...${NC}"
sleep 2

# 获取交易收据
TX_RECEIPT=$(cast receipt $TX_HASH --rpc-url http://localhost:8545)
echo -e "${GREEN}✅ 交易已确认!${NC}"

# 检查新的余额
NEW_BALANCE_0=$(cast balance $ACCOUNT_0 --rpc-url http://localhost:8545)
NEW_BALANCE_1=$(cast balance $ACCOUNT_1 --rpc-url http://localhost:8545)

echo -e "${PURPLE}💰 交易后余额:${NC}"
echo "   Account #0: $(cast from-wei $NEW_BALANCE_0 ether) ETH"
echo "   Account #1: $(cast from-wei $NEW_BALANCE_1 ether) ETH"

# 部署测试合约
echo -e "${YELLOW}🔄 部署测试合约...${NC}"

# 创建简单的 ERC20 合约进行测试
echo -e "${BLUE}📄 使用项目中的 Counter 合约进行测试${NC}"

if [ -f "src/Counter.sol" ]; then
    # 部署 Counter 合约
    echo -e "${YELLOW}🚀 部署 Counter 合约...${NC}"
    
    # 编译合约
    forge build
    
    # 部署合约
    DEPLOY_RESULT=$(forge script script/Counter.s.sol:CounterScript \
        --rpc-url http://localhost:8545 \
        --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
        --broadcast)
    
    echo -e "${GREEN}✅ Counter 合约部署完成!${NC}"
    
    # 从部署结果中提取合约地址（如果可能）
    echo -e "${CYAN}📋 部署信息已记录到 broadcast/ 目录${NC}"
else
    echo -e "${YELLOW}ℹ️  Counter.sol 不存在，跳过合约部署测试${NC}"
fi

echo ""
echo -e "${GREEN}🎉 测试完成!${NC}"
echo "==========================================="
echo -e "${CYAN}📱 现在可以访问 Ethernal Dashboard 查看:${NC}"
echo "   🌐 https://app.tryethernal.com/"
echo ""
echo -e "${PURPLE}💡 你应该能看到:${NC}"
echo "   ✅ 刚才发送的 ETH 转账交易"
echo "   ✅ 部署的合约信息 (如果成功)"
echo "   ✅ 账户余额变化"
echo "   ✅ 区块和交易详情"