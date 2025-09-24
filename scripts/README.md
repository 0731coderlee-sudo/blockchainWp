# README自动更新工具使用说明

## 🎯 目标

保持README文件中的项目信息、时间戳和状态始终为最新，减少手动维护工作量。

## 🛠 可用方案

### 1. GitHub Actions 自动更新 (最推荐)

**优点**: 
- 完全自动化，每次push后自动运行
- 无需本地操作
- 与GitHub完美集成

**使用方法**:
- 文件已创建: `.github/workflows/update-readme.yml`
- 每次push到main分支时自动运行
- 无需任何手动操作

### 2. Shell脚本手动更新

**优点**:
- 快速简单
- 本地运行，即时查看结果
- 适合快速更新

**使用方法**:
```bash
# 运行更新脚本
./scripts/update-readme.sh

# 提交更改
git add README.md
git commit -m "📝 Update README timestamps"
git push
```

### 3. Python脚本智能更新

**优点**:
- 功能最强大
- 自动检测项目状态
- 可扩展性强

**使用方法**:
```bash
# 运行Python更新脚本
python3 scripts/update_readme.py

# 或者直接执行
./scripts/update_readme.py

# 提交更改
git add README.md
git commit -m "📝 Update README timestamps"
git push
```

## 🔄 自动化工作流程

### 推荐工作流程:

1. **开发新项目** → 创建新文件夹和文件
2. **提交代码** → `git add . && git commit -m "Add new project"`
3. **自动更新** → GitHub Action自动运行更新README
4. **推送代码** → `git push` (如果使用本地脚本，需要额外提交README)

### 手动工作流程:

1. **完成项目开发**
2. **运行更新脚本** → `./scripts/update-readme.sh` 或 `python3 scripts/update_readme.py`
3. **查看更改** → `git diff README.md`
4. **提交所有更改** → `git add . && git commit -m "Add project and update README"`
5. **推送到远程** → `git push`

## 📋 自动更新的内容

- ✅ **项目时间戳**: 基于git提交记录自动更新
- ✅ **项目状态**: 
  - 有`rs.txt`文件 → "✅ 已部署"
  - 有Python/Solidity文件 → "✅ 完成"  
  - 其他 → "🚧 开发中"
- ✅ **最后更新时间**: README底部的更新时间
- ✅ **项目链接**: 保持现有链接不变

## 🎨 自定义配置

### 修改检测规则:

编辑 `scripts/update_readme.py` 中的 `detect_project_status()` 方法:

```python
def detect_project_status(self, project_path):
    # 添加你的自定义检测逻辑
    if (project_path / "package.json").exists():
        return "✅ Node.js项目"
    # ... 其他规则
```

### 修改时间格式:

将 `%Y-%m` 改为你想要的格式，例如:
- `%Y-%m-%d` → 2024-09-24
- `%m/%d/%Y` → 09/24/2024

## 🚀 建议使用方式

**对于个人项目**: 使用GitHub Actions (方案1)，完全自动化
**对于需要精确控制**: 使用Python脚本 (方案3)，功能最强
**对于快速更新**: 使用Shell脚本 (方案2)，简单快捷

---

💡 **提示**: 可以将 `./scripts/update-readme.sh` 添加到你的开发工作流中，或设置为git hooks！