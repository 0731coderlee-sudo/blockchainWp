#!/bin/bash

# 🛑 Foundry + Ethernal 环境停止脚本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🛑 停止 Foundry + Ethernal 环境${NC}"
echo "==========================================="

# 停止所有相关进程
echo -e "${YELLOW}🔄 停止 Anvil 进程...${NC}"
pkill -f "anvil" && echo -e "${GREEN}✅ Anvil 已停止${NC}" || echo -e "${YELLOW}ℹ️  无运行中的 Anvil 进程${NC}"

echo -e "${YELLOW}🔄 停止 Ethernal 进程...${NC}"
pkill -f "ethernal" && echo -e "${GREEN}✅ Ethernal 已停止${NC}" || echo -e "${YELLOW}ℹ️  无运行中的 Ethernal 进程${NC}"

# 检查端口占用
if lsof -i :8545 >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  端口 8545 仍被占用，强制释放...${NC}"
    lsof -ti:8545 | xargs kill -9 || true
fi

echo -e "${GREEN}✅ 所有服务已停止${NC}"
echo -e "${GREEN}🎉 环境已清理完成！${NC}"