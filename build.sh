#!/bin/bash
# Hugo Build Script - 自动清理并构建最新版本
# Usage: ./build.sh [--clean] [--no-minify] [--serve]

set -e

CLEAN=false
MINIFY=true
SERVE=false

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --clean)
            CLEAN=true
            shift
            ;;
        --no-minify)
            MINIFY=false
            shift
            ;;
        --serve)
            SERVE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: ./build.sh [--clean] [--no-minify] [--serve]"
            exit 1
            ;;
    esac
done

echo "======================================================================"
echo "Hugo Build Script"
echo "======================================================================"
echo ""

# 步骤 1: 清理 (可选)
if [ "$CLEAN" = true ]; then
    echo "📦 Step 1: Cleaning public directory..."
    if [ -d "public" ]; then
        rm -rf public
        echo "✅ Cleaned public directory"
    else
        echo "⚠️  public directory not found, skipping"
    fi
    echo ""
fi

# 步骤 2: 构建
echo "🔨 Step 2: Building site..."

BUILD_ARGS="--gc"

if [ "$MINIFY" = true ]; then
    BUILD_ARGS="$BUILD_ARGS --minify"
    echo "   - Minification: Enabled"
fi

echo "   - Running: hugo $BUILD_ARGS"

if hugo $BUILD_ARGS; then
    echo "✅ Build completed successfully"
else
    echo "❌ Build failed"
    exit 1
fi

echo ""

# 步骤 3: 验证
echo "🔍 Step 3: Verifying build..."

if [ -f "public/index.html" ]; then
    PUBLIC_SIZE=$(du -sh public | cut -f1)
    
    echo "✅ Build verified"
    echo "   - Output directory: public/"
    echo "   - Total size: $PUBLIC_SIZE"
    
    # 统计文件数量
    HTML_FILES=$(find public -name "*.html" | wc -l)
    CSS_FILES=$(find public -name "*.css" | wc -l)
    JS_FILES=$(find public -name "*.js" | wc -l)
    
    echo "   - HTML files: $HTML_FILES"
    echo "   - CSS files: $CSS_FILES"
    echo "   - JS files: $JS_FILES"
else
    echo "❌ Build verification failed: index.html not found"
    exit 1
fi

echo ""

# 步骤 4: 启动服务器 (可选)
if [ "$SERVE" = true ]; then
    echo "🚀 Step 4: Starting development server..."
    echo "   - Press Ctrl+C to stop"
    echo ""
    
    hugo server -D
else
    echo "✨ Build complete!"
    echo ""
    echo "Next steps:"
    echo "1. Preview: hugo server -D"
    echo "2. Deploy: Upload public/ directory"
    echo "3. Or run: ./build.sh --serve"
fi

echo ""
