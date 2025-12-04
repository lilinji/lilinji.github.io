#!/bin/bash
# Deploy to GitHub Pages
# Usage: ./deploy.sh ["commit message"]

set -e

MESSAGE="${1:-Deploy site $(date '+%Y-%m-%d %H:%M')}"

echo "======================================================================"
echo "Deploy to GitHub Pages"
echo "======================================================================"
echo ""

# 检查是否有 public 目录
if [ ! -d "public" ]; then
    echo "❌ Error: public/ directory not found"
    echo "   Please run: ./build.sh"
    exit 1
fi

# 检查是否有 index.html
if [ ! -f "public/index.html" ]; then
    echo "❌ Error: public/index.html not found"
    echo "   Please run: ./build.sh"
    exit 1
fi

echo "📦 Step 1: Preparing deployment..."
echo "   - Commit message: $MESSAGE"
echo ""

# 进入 public 目录
cd public

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
    cd ..
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
    cd ..
    exit 1
fi

# 返回原目录
cd ..

echo "📊 Deployment Summary:"
echo "   - Commit: $MESSAGE"
echo "   - Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""
