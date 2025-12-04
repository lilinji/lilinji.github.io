#!/bin/bash

# Hugo 项目快速设置脚本 (Bash)

echo "=== Hugo 项目设置脚本 ==="
echo ""

# 检查 Hugo 是否安装
echo "检查 Hugo 安装..."
if command -v hugo &> /dev/null; then
    HUGO_VERSION=$(hugo version)
    echo "✓ Hugo 已安装: $HUGO_VERSION"
else
    echo "✗ Hugo 未安装"
    echo "请先安装 Hugo Extended: https://gohugo.io/installation/"
    exit 1
fi

# 检查 Git 是否安装
echo "检查 Git 安装..."
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    echo "✓ Git 已安装: $GIT_VERSION"
else
    echo "✗ Git 未安装"
    echo "请先安装 Git: https://git-scm.com/downloads"
    exit 1
fi

# 安装主题
echo ""
echo "安装 PaperMod 主题..."

if [ -d "themes/PaperMod" ]; then
    echo "✓ 主题已存在，跳过安装"
else
    echo "正在克隆主题..."
    git clone --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
    if [ $? -eq 0 ]; then
        echo "✓ 主题安装成功"
    else
        echo "✗ 主题安装失败"
        exit 1
    fi
fi

# 创建必要的目录
echo ""
echo "创建目录结构..."

directories=(
    "content/posts"
    "static/images"
    "static/css"
)

for dir in "${directories[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "✓ 创建目录: $dir"
    else
        echo "✓ 目录已存在: $dir"
    fi
done

# 复制静态资源（如果存在）
echo ""
echo "检查静态资源..."

static_files=(
    "favicon_wine.ico"
    "favicon_peach.ico"
)

for file in "${static_files[@]}"; do
    if [ -f "$file" ] && [ ! -f "static/$file" ]; then
        cp "$file" "static/$file"
        echo "✓ 复制文件: $file"
    fi
done

echo ""
echo "=== 设置完成 ==="
echo ""
echo "下一步操作:"
echo "1. 启动开发服务器: hugo server -D"
echo "2. 访问 http://localhost:1313 查看网站"
echo "3. 创建新文章: hugo new posts/2024-12-03-title/index.md"
echo ""

