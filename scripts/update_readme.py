#!/usr/bin/env python3
"""
README自动更新器
自动更新项目时间戳、状态和统计信息
"""

import os
import re
import subprocess
from datetime import datetime
from pathlib import Path

class READMEUpdater:
    def __init__(self, repo_path="."):
        self.repo_path = Path(repo_path)
        self.readme_path = self.repo_path / "README.md"
        
    def get_git_last_modified(self, path):
        """获取文件/文件夹的最后git提交时间"""
        try:
            result = subprocess.run(
                ["git", "log", "-1", "--format=%Y-%m", "--", str(path)],
                capture_output=True,
                text=True,
                cwd=self.repo_path
            )
            if result.stdout.strip():
                return result.stdout.strip()
            else:
                return datetime.now().strftime("%Y-%m")
        except:
            return datetime.now().strftime("%Y-%m")
    
    def scan_projects(self):
        """扫描项目文件夹"""
        projects = []
        for item in self.repo_path.iterdir():
            if item.is_dir() and not item.name.startswith('.') and item.name not in ['scripts', 'node_modules']:
                last_modified = self.get_git_last_modified(item)
                projects.append({
                    'name': item.name,
                    'path': item,
                    'last_modified': last_modified,
                    'status': self.detect_project_status(item)
                })
        return projects
    
    def detect_project_status(self, project_path):
        """检测项目状态"""
        # 检查是否有部署记录
        if (project_path / "rs.txt").exists():
            return "✅ 已部署"
        
        # 检查是否有Python文件
        if any(project_path.glob("*.py")):
            return "✅ 完成"
            
        # 检查是否有Solidity文件
        if any(project_path.glob("*.sol")):
            return "✅ 完成"
            
        return "🚧 开发中"
    
    def update_project_table(self, projects):
        """更新项目表格"""
        if not self.readme_path.exists():
            print("❌ README.md 文件不存在")
            return False
            
        with open(self.readme_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # 更新项目表格中的时间
        for project in projects:
            # 匹配表格行并更新时间
            pattern = f"(.*{project['name']}.* \| .* \| .* \| .* \| )([0-9]{{4}}-[0-9]{{2}})( \|)"
            replacement = f"\\g<1>{project['last_modified']}\\g<3>"
            content = re.sub(pattern, replacement, content)
            
            # 更新状态
            status_pattern = f"(\| .*{project['name']}.* \| .* \| .* \| )([^|]+)( \| [0-9]{{4}}-[0-9]{{2}} \|)"
            status_replacement = f"\\g<1>{project['status']}\\g<3>"
            content = re.sub(status_pattern, status_replacement, content)
        
        # 更新最后更新时间
        current_date = datetime.now().strftime("%Y-%m")
        content = re.sub(
            r'\*\*持续更新中\.\.\. 🚀\*\*',
            f'**最后更新: {current_date} 🚀**',
            content
        )
        
        with open(self.readme_path, 'w', encoding='utf-8') as f:
            f.write(content)
            
        return True
    
    def run(self):
        """运行更新流程"""
        print("🔄 开始更新README文件...")
        
        # 扫描项目
        projects = self.scan_projects()
        print(f"📁 发现 {len(projects)} 个项目:")
        
        for project in projects:
            print(f"  📂 {project['name']} - {project['status']} - 更新于 {project['last_modified']}")
        
        # 更新README
        if self.update_project_table(projects):
            print("✅ README文件更新成功!")
            print("💡 记得提交更改: git add README.md && git commit -m '📝 Update README timestamps'")
        else:
            print("❌ README文件更新失败!")

if __name__ == "__main__":
    updater = READMEUpdater()
    updater.run()