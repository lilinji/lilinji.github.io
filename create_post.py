#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Create New Post Script for Hugo Blog
Usage: python create_post.py "文章标题" ["tag1,tag2"]
"""

import os
import sys
import re
from datetime import datetime
from pathlib import Path


class PostCreator:
    """Hugo 文章创建器"""
    
    def __init__(self, author="Ringi Lee", content_dir="content/posts"):
        self.author = author
        self.content_dir = Path(content_dir)
    
    def slugify(self, text):
        """将文本转换为 URL 友好的 slug"""
        # 替换空格为连字符
        slug = re.sub(r'\s+', '-', text)
        # 移除非字母数字字符(保留中文)
        slug = re.sub(r'[^\w\-\u4e00-\u9fa5]', '', slug)
        # 合并多个连字符
        slug = re.sub(r'-+', '-', slug)
        # 移除首尾连字符
        slug = slug.strip('-')
        return slug
    
    def create_post(self, title, tags="AI,DeepLearning"):
        """创建新文章"""
        # 获取当前日期和时间
        now = datetime.now()
        date_str = now.strftime('%Y-%m-%d')
        datetime_str = now.strftime('%Y-%m-%dT%H:%M:%S+08:00')
        
        # 生成 slug
        slug = self.slugify(title)
        
        # 创建目录
        dir_name = f"{date_str}-{slug}"
        post_dir = self.content_dir / dir_name
        
        # 检查目录是否存在
        if post_dir.exists():
            print(f"❌ 错误: 目录已存在: {post_dir}")
            return False
        
        # 创建目录
        try:
            post_dir.mkdir(parents=True, exist_ok=False)
            print(f"✅ 创建目录: {post_dir}")
        except Exception as e:
            print(f"❌ 创建目录失败: {e}")
            return False
        
        # 处理标签
        tag_list = [tag.strip() for tag in tags.split(',') if tag.strip()]
        tags_yaml = '\n'.join(f'- {tag}' for tag in tag_list)
        
        # 生成 front matter
        front_matter = f"""---
title: {title}
date: {datetime_str}
draft: false
tags:
{tags_yaml}
author: {self.author}
showToc: true
tocOpen: false
---

# {title}

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
"""
        
        # 写入文件
        index_file = post_dir / "index.md"
        try:
            with open(index_file, 'w', encoding='utf-8') as f:
                f.write(front_matter)
            print(f"✅ 创建文件: {index_file}")
        except Exception as e:
            print(f"❌ 创建文件失败: {e}")
            return False
        
        # 打印摘要
        print()
        print("=" * 70)
        print("Article Created Successfully!")
        print("=" * 70)
        print()
        print(f"Title:     {title}")
        print(f"Date:      {datetime_str}")
        print(f"Directory: {post_dir}")
        print(f"Tags:      {', '.join(tag_list)}")
        print()
        print("Next Steps:")
        print(f"1. Edit file: {index_file}")
        print(f"2. Add images to: {post_dir}")
        print("3. Preview: hugo server -D")
        print()
        
        return True


def main():
    """主函数"""
    # 检查参数
    if len(sys.argv) < 2:
        print("❌ 错误: 请提供文章标题")
        print("用法: python create_post.py \"文章标题\" [\"标签1,标签2\"]")
        print("示例: python create_post.py \"AI技术大全\" \"AI,DeepLearning\"")
        sys.exit(1)
    
    # 获取参数
    title = sys.argv[1]
    tags = sys.argv[2] if len(sys.argv) > 2 else "AI,DeepLearning"
    
    # 创建文章
    creator = PostCreator()
    success = creator.create_post(title, tags)
    
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
