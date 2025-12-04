#!/bin/bash
# Deploy to GitHub Pages
# Usage: ./deploy.sh ["commit message"]

set -e

MESSAGE="${1:-Deploy site $(date '+%Y-%m-%d %H:%M')}"

echo "======================================================================"
echo "Deploy to GitHub Pages"
echo "======================================================================"
echo ""

# 不再检查 public 目录或 index.html，部署整个仓库（遵循 .gitignore）

echo "📦 Step 1: Preparing deployment..."
echo "   - Commit message: $MESSAGE"
echo ""

# 在仓库根目录进行部署（不切换目录）

# 初始化 git (如果需要)
if [ ! -d ".git" ]; then
    echo "🔧 Initializing git repository..."
    git init
    git branch -M main
    echo "✅ Git initialized"
fi

echo ""
echo "📝 Step 2: Staging files..."

# 添加所有文件
git add -A

if git status --short | grep -q .; then
    echo "✅ Files staged:"
    git status --short
else
    echo "⚠️  No changes to deploy"
    exit 0
fi

echo ""
echo "💾 Step 3: Committing changes..."

git commit -m "$MESSAGE"
echo "✅ Changes committed"

echo ""
echo "🚀 Step 4: Pushing to GitHub..."
echo "   - Repository: https://github.com/lilinji/lilinji.github.io"
echo "   - Branch: main"
echo ""

# 推送到 GitHub (强制推送以替换所有内容)
if git push -f https://github.com/lilinji/lilinji.github.io.git main; then
    echo ""
    echo "======================================================================"
    echo "✨ Deployment Successful!"
    echo "======================================================================"
    echo ""
    echo "🌐 Your site will be available at:"
    echo "   https://lilinji.github.io"
    echo ""
    echo "⏱️  Note: GitHub Pages may take a few minutes to update"
    echo ""
else
    echo "❌ Push failed"
    echo "   Please check your GitHub credentials and repository access"
    exit 1
fi

# 保持在仓库根目录

echo "📊 Deployment Summary:"
echo "   - Commit: $MESSAGE"
echo "   - Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""
