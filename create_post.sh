#!/bin/bash
# Create New Post Script for Hugo Blog
# Usage: ./create_post.sh "文章标题" ["tag1,tag2"]

set -e

# 配置
AUTHOR="Ringi Lee"
CONTENT_DIR="content/posts"

# 获取参数
TITLE="${1:-}"
TAGS="${2:-AI,DeepLearning}"

# 检查标题参数
if [ -z "$TITLE" ]; then
    echo "❌ 错误: 请提供文章标题"
    echo "用法: ./create_post.sh \"文章标题\" [\"标签1,标签2\"]"
    echo "示例: ./create_post.sh \"AI技术大全\" \"AI,DeepLearning\""
    exit 1
fi

# 获取当前日期和时间 - ISO 8601 格式
DATE=$(date +%Y-%m-%d)
DATETIME=$(date +%Y-%m-%dT%H:%M:%S+08:00)

# 生成文件名友好的 slug
SLUG=$(echo "$TITLE" | sed -e 's/[[:space:]]\+/-/g' \
                           -e 's/[^[:alnum:]\-\u4e00-\u9fa5]//g' \
                           -e 's/-\+/-/g' \
                           -e 's/^-\|-$//g')

# 创建目录名
DIR_NAME="${DATE}-${SLUG}"
POST_DIR="${CONTENT_DIR}/${DIR_NAME}"

# 检查目录是否已存在
if [ -d "$POST_DIR" ]; then
    echo "❌ 错误: 目录已存在: $POST_DIR"
    exit 1
fi

# 创建目录
mkdir -p "$POST_DIR"
echo "✅ 创建目录: $POST_DIR"

# 处理标签
IFS=',' read -ra TAG_ARRAY <<< "$TAGS"
TAGS_YAML=""
for tag in "${TAG_ARRAY[@]}"; do
    tag=$(echo "$tag" | xargs)  # 去除空格
    TAGS_YAML="${TAGS_YAML}- ${tag}\n"
done

# 创建文件
INDEX_FILE="${POST_DIR}/index.md"

# 生成 front matter
cat > "$INDEX_FILE" << EOF
---
title: $TITLE
date: $DATETIME
draft: false
tags:
$(echo -e "$TAGS_YAML" | sed 's/^//')author: $AUTHOR
showToc: true
tocOpen: false
---

# $TITLE

## Introduction

Start writing here...

## Main Content

### Section 1

Content...

### Section 2

Content...

## Summary

Summary content...

## References

- [Reference 1](https://example.com)
- [Reference 2](https://example.com)
EOF

echo "✅ 创建文件: $INDEX_FILE"

# 打印摘要
echo ""
echo "======================================================================"
echo "Article Created Successfully!"
echo "======================================================================"
echo ""
echo "Title:     $TITLE"
echo "Date:      $DATETIME"
echo "Directory: $POST_DIR"
echo "Tags:      ${TAGS//,/, }"
echo ""
echo "Next Steps:"
echo "1. Edit file: $INDEX_FILE"
echo "2. Add images to: $POST_DIR"
echo "3. Preview: hugo server -D"
echo ""
