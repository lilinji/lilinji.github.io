# Hugo 项目设置指南

## 快速开始

### 1. 安装 Hugo Extended

**Windows:**
```powershell
# 使用 Chocolatey
choco install hugo-extended

# 或下载安装包
# https://github.com/gohugoio/hugo/releases
```

**macOS:**
```bash
brew install hugo
```

**Linux:**
```bash
# 下载并安装
wget https://github.com/gohugoio/hugo/releases/download/v0.139.3/hugo_extended_0.139.3_linux-amd64.deb
sudo dpkg -i hugo_extended_0.139.3_linux-amd64.deb
```

### 2. 安装主题

```bash
# 克隆主题到 themes 目录
git clone --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod

# 或者使用 Git 子模块（推荐）
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
git submodule update --init --recursive
```

### 3. 验证安装

```bash
# 检查 Hugo 版本
hugo version

# 应该显示类似：hugo v0.139.3+extended ...
```

### 4. 启动开发服务器

```bash
# 启动服务器（包含草稿）
hugo server -D

# 访问 http://localhost:1313
```

## 项目结构说明

```
lilinji.github.io/
├── content/              # 内容目录
│   ├── posts/           # 博客文章
│   │   └── YYYY-MM-DD-slug/
│   │       ├── index.md
│   │       └── images/  # 文章图片
│   └── faq/             # FAQ 页面
│       └── index.md
├── static/              # 静态资源（会直接复制到 public/）
│   ├── favicon_wine.ico
│   └── ...
├── themes/              # 主题目录
│   └── PaperMod/
├── hugo.yaml           # Hugo 配置文件
├── .gitignore          # Git 忽略文件
├── README.md           # 项目说明
└── SETUP.md            # 本文件
```

## 添加新文章步骤

### 方法 1: 使用 Hugo 命令（推荐）

```bash
# 创建新文章
hugo new posts/2024-12-03-my-article/index.md

# 编辑文件
# 文件位置：content/posts/2024-12-03-my-article/index.md
```

### 方法 2: 手动创建

1. 创建目录：`content/posts/2024-12-03-my-article/`
2. 创建文件：`index.md`
3. 添加 front matter 和内容

### Front Matter 模板

```yaml
---
title: "文章标题"
date: 2024-12-03T00:00:00Z
draft: false                    # false = 发布，true = 草稿
tags: ["tag1", "tag2"]
categories: ["category1"]
description: "文章描述（用于 SEO）"
keywords: ["keyword1", "keyword2"]
author: "Ringi Lee"
showToc: true                  # 显示目录
tocOpen: false                 # 目录默认是否展开
---
```

## 图片管理

### 推荐方式：文章目录内

```
content/posts/2024-12-03-my-article/
├── index.md
├── image1.png
├── image2.jpg
└── images/
    └── image3.png
```

在 Markdown 中引用：
```markdown
![Alt text](image1.png)
![Alt text](images/image3.png)
```

### 全局静态资源

放在 `static/` 目录下：
```
static/
└── images/
    └── logo.png
```

引用时使用绝对路径：
```markdown
![Logo](/images/logo.png)
```

## 构建和部署

### 本地构建

```bash
# 生成静态文件
hugo

# 生成的文件在 public/ 目录
```

### 部署到 GitHub Pages

#### 使用 GitHub Actions（已配置）

1. 确保 `.github/workflows/hugo.yml` 存在
2. 推送代码到 `main` 分支
3. GitHub Actions 会自动构建和部署
4. 在仓库设置中启用 GitHub Pages，选择 "GitHub Actions" 作为源

#### 手动部署

```bash
# 构建
hugo

# 进入 public 目录
cd public

# 初始化 Git（如果还没有）
git init
git add .
git commit -m "Deploy site"

# 推送到 GitHub
git remote add origin https://github.com/lilinji/lilinji.github.io.git
git branch -M main
git push -u origin main --force
```

## 常用命令

```bash
# 创建新文章
hugo new posts/2024-12-03-title/index.md

# 启动开发服务器（包含草稿）
hugo server -D

# 启动开发服务器（不包含草稿）
hugo server

# 构建生产版本
hugo --minify

# 检查配置
hugo config

# 列出所有内容
hugo list all

# 列出草稿
hugo list drafts
```

## 从现有 HTML 恢复内容

如果你有现有的 HTML 文章需要转换为 Markdown：

1. **提取内容**：从 `posts/YYYY-MM-DD-slug/index.html` 中提取正文
2. **转换格式**：使用工具如 `pandoc` 或手动转换
3. **创建 Markdown**：在 `content/posts/YYYY-MM-DD-slug/index.md` 创建文件
4. **移动图片**：将图片从 `posts/` 目录移动到 `content/posts/` 对应目录

### 使用 Pandoc 转换

```bash
# 安装 pandoc
# Windows: choco install pandoc
# macOS: brew install pandoc
# Linux: sudo apt install pandoc

# 转换单个文件
pandoc posts/2017-08-20-gan/index.html -o content/posts/2017-08-20-gan/index.md
```

## 主题自定义

### 覆盖主题模板

创建对应的文件结构来覆盖主题文件：

```
layouts/
└── _default/
    └── baseof.html  # 覆盖基础模板
```

### 自定义 CSS

在 `static/css/custom.css` 添加自定义样式，然后在 `hugo.yaml` 中引用。

## 故障排除

### Hugo 版本不匹配

确保使用 Hugo Extended 版本 >= 0.139.3：
```bash
hugo version
```

### 主题未找到

检查主题是否正确安装：
```bash
ls themes/PaperMod
```

如果不存在，重新安装：
```bash
git submodule update --init --recursive
```

### 图片不显示

1. 检查图片路径是否正确
2. 确保图片文件存在
3. 使用相对路径引用（推荐）

### 构建错误

```bash
# 查看详细错误信息
hugo --verbose

# 检查配置文件语法
hugo config
```

## 下一步

1. ✅ 安装 Hugo Extended
2. ✅ 安装 PaperMod 主题
3. ✅ 创建第一篇文章
4. ✅ 本地预览
5. ✅ 配置 GitHub Actions
6. ✅ 部署到 GitHub Pages

## 参考资源

- [Hugo 官方文档](https://gohugo.io/documentation/)
- [PaperMod 主题文档](https://github.com/adityatelange/hugo-PaperMod/wiki)
- [Hugo 快速开始](https://gohugo.io/getting-started/quick-start/)
- [Markdown 语法](https://www.markdownguide.org/)

