#!/bin/bash

# README自动更新脚本
# 使用方法: ./scripts/update-readme.sh

echo "🔄 正在更新README文件..."

# 获取当前日期 (YYYY-MM格式)
CURRENT_DATE=$(date +"%Y-%m")

# 获取项目文件夹列表
PROJECTS=$(find . -maxdepth 1 -type d -name "*" ! -name ".*" ! -name "scripts" | sort)

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}📁 发现的项目文件夹:${NC}"
for project in $PROJECTS; do
    if [ "$project" != "." ]; then
        # 获取文件夹最后修改时间
        LAST_MODIFIED=$(git log -1 --format="%Y-%m" -- "$project" 2>/dev/null || echo "$CURRENT_DATE")
        echo -e "  ${GREEN}${project}${NC} - 最后更新: ${YELLOW}$LAST_MODIFIED${NC}"
        
        # 更新README中对应项目的时间
        project_name=$(basename "$project")
        if grep -q "$project_name" README.md; then
            # 使用sed替换对应行的日期
            sed -i.bak "s/\(.*$project_name.*\) [0-9]\{4\}-[0-9]\{2\} |/\1 $LAST_MODIFIED |/" README.md
        fi
    fi
done

# 更新总体最后更新时间
sed -i.bak "s/\*\*持续更新中\.\.\. 🚀\*\*/\*\*最后更新: $CURRENT_DATE 🚀\*\*/" README.md

# 清理备份文件
rm -f README.md.bak

echo -e "${GREEN}✅ README文件更新完成!${NC}"
echo -e "${YELLOW}💡 提示: 记得提交更改到git仓库${NC}"