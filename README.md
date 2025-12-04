# Ringi's Log

> 基于 Hugo + PaperMod 主题的技术博客,记录云计算、容器技术、OpenStack、Ceph 存储等领域的学习笔记与实践经验。

[![Hugo](https://img.shields.io/badge/Hugo-0.139.3-blue.svg)](https://gohugo.io)
[![Theme](https://img.shields.io/badge/Theme-PaperMod-green.svg)](https://github.com/adityatelange/hugo-PaperMod)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## 📚 博客内容

- 🐳 **容器技术**: Docker、容器编排、镜像管理
- ☁️ **OpenStack**: 虚拟机管理、Cinder、Nova、Mistral 等组件
- 💾 **存储技术**: Ceph、RBD、分布式存储
- 🐧 **Linux 运维**: 网络工具、系统配置、性能优化
- 📊 **算法与编程**: 数据结构、算法实现

**文章统计**: 31 篇技术文章 (2013-2017)

## 🚀 快速开始

### 环境要求

- [Hugo Extended](https://gohugo.io/installation/) >= 0.139.3
- Git

### 安装 Hugo

<details>
<summary>Windows (Chocolatey)</summary>

```powershell
choco install hugo-extended
```
</details>

<details>
<summary>macOS (Homebrew)</summary>

```bash
brew install hugo
```
</details>

<details>
<summary>Linux</summary>

```bash
# 下载最新版本
wget https://github.com/gohugoio/hugo/releases/download/v0.139.3/hugo_extended_0.139.3_linux-amd64.deb
sudo dpkg -i hugo_extended_0.139.3_linux-amd64.deb
```
</details>

### 克隆项目

```bash
# 克隆仓库
git clone https://github.com/lilinji/lilinji.github.io.git
cd lilinji.github.io

# 安装主题 (如果使用 Git 子模块)
git submodule update --init --recursive
```

### 本地预览

```bash
# 启动开发服务器
hugo server -D

# 访问 http://localhost:1313
```

## 📝 写作指南

### 创建新文章

项目提供了 **4 个版本**的快捷脚本,适用于不同平台:

**Windows 用户** (推荐):

```cmd
# 方法 1: 使用批处理文件 (最简单)
create_post "文章标题" "标签1,标签2"

# 方法 2: 使用 PowerShell
powershell -ExecutionPolicy Bypass -File create_post.ps1 "文章标题" "标签1,标签2"
```

**Linux/macOS 用户**:

```bash
# 添加执行权限 (首次使用)
chmod +x create_post.sh

# 创建文章
./create_post.sh "文章标题" "标签1,标签2"
```

**跨平台** (Python):

```bash
python create_post.py "文章标题" "标签1,标签2"
```

**使用示例**:

```cmd
# 使用默认标签 (AI,DeepLearning)
create_post "AI技术大全"

# 自定义标签
create_post "Docker容器技术" "Docker,Container,DevOps"

# 中文标题
create_post "深度学习入门" "AI,DeepLearning,Tutorial"
content/posts/2024-12-03-my-post/
├── index.md
└── image.png
```

```markdown
![图片描述](image.png)
```

## 🏗️ 项目结构

### 标准目录结构

```
lilinji.github.io/
├── .github/              # GitHub Actions 配置
├── .gitignore           # Git 忽略文件
├── assets/              # 自定义资源 (CSS, JS)
├── content/             # 内容源文件 ✅
│   ├── archives/        # 归档页面
│   ├── faq/             # FAQ 页面
│   ├── posts/           # 博客文章 (31篇)
│   └── search/          # 搜索页面
├── public/              # Hugo 构建输出 (git ignored)
├── themes/              # Hugo 主题
│   └── PaperMod/        # PaperMod 主题
├── hugo.yaml            # Hugo 配置 ✅
├── README.md            # 项目说明 ✅
├── migrate_jekyll_to_hugo.py  # 迁移脚本 (保留作为记录)
├── favicon_wine.ico     # 网站图标
├── setup.sh             # 安装脚本
└── setup.ps1            # Windows 安装脚本
```

### 📁 目录说明

| 目录/文件 | 说明 | 是否提交到 Git |
|----------|------|---------------|
| `content/` | 文章源文件 | ✅ 是 |
| `public/` | Hugo 构建输出 | ❌ 否 |
| `resources/` | Hugo 资源缓存 | ❌ 否 |
| `themes/` | Hugo 主题 | ✅ 是 |
| `hugo.yaml` | Hugo 配置 | ✅ 是 |
| `.gitignore` | Git 忽略规则 | ✅ 是 |

### 🏷️ Tags 目录说明

> **重要**: `tags/` 目录是 Hugo **自动生成**的分类页面,不是源文件目录。

**工作原理**:
- **源文件**: 在 `content/posts/*/index.md` 的 front matter 中定义 `tags: [...]`
- **生成位置**: Hugo 构建时自动生成到 `public/tags/`
- **访问方式**: 通过网站菜单 "Tags" 链接访问

**你不需要手动创建或管理 tags 目录!** Hugo 会自动处理。

**示例**:
```yaml
---
title: "我的文章"
tags: ["Docker", "OpenStack", "Ceph"]
---
```

Hugo 会自动创建:
- `/tags/docker/` - Docker 标签页面
- `/tags/openstack/` - OpenStack 标签页面
- `/tags/ceph/` - Ceph 标签页面
- `/tags/` - 所有标签列表页面

## 🔧 配置说明

主要配置文件: `hugo.yaml`

<details>
<summary>核心配置项</summary>

```yaml
baseURL: 'https://lilinji.github.io/'
languageCode: 'zh-cn'
title: "Ringi's Log"
theme: 'PaperMod'

params:
  description: "记录云计算、容器技术的学习笔记"
  author: "Ringi Li"
  ShowReadingTime: true
  ShowCodeCopyButtons: true
  ShowToc: true
```
</details>

详细配置请参考 [hugo.yaml](hugo.yaml)

## 📦 构建与部署

### 快捷构建脚本 (推荐)

使用自动化脚本一键构建:

**Windows**:
```powershell
# 基本构建 (自动清理 + 压缩)
.\build.ps1

# 完全清理后构建
.\build.ps1 -Clean

# 构建并启动服务器
.\build.ps1 -Serve

# 不压缩 (开发模式)
.\build.ps1 -Minify:$false
```

**Linux/macOS**:
```bash
# 添加执行权限 (首次)
chmod +x build.sh

# 基本构建
./build.sh

# 完全清理后构建
./build.sh --clean

# 构建并启动服务器
./build.sh --serve
```

**脚本功能**:
- ✅ 自动清理缓存 (`--gc`)
- ✅ 压缩输出文件 (`--minify`)
- ✅ 验证构建结果
- ✅ 显示构建统计
- ✅ 可选启动服务器

### 手动构建

```bash
# 生成静态文件到 public/
hugo

# 生成并最小化
hugo --minify
```

### GitHub Pages 部署

#### 方法 1: 使用部署脚本 (推荐)

**Windows**:
```powershell
# 基本部署
.\deploy.ps1

# 自定义提交信息
.\deploy.ps1 -Message "更新文章"
```

**Linux/macOS**:
```bash
# 添加执行权限 (首次)
chmod +x deploy.sh

# 基本部署
./deploy.sh

# 自定义提交信息
./deploy.sh "更新文章"
```

**脚本功能**:
- ✅ 自动检查 `public/` 目录
- ✅ 初始化 Git 仓库 (如需)
- ✅ 添加所有文件
- ✅ 提交并强制推送到 GitHub
- ✅ 显示部署结果

> **注意**: 脚本使用 `git push -f` 强制推送,会替换 GitHub 仓库的所有内容

#### 方法 2: GitHub Actions (自动化)

项目已配置 `.github/workflows/hugo.yml`,推送到 `main` 分支自动部署。

#### 方法 2: 手动部署

```bash
# 构建
hugo --minify

# 部署到 gh-pages 分支
cd public
git init
git add .
git commit -m "Deploy"
git push -f git@github.com:lilinji/lilinji.github.io.git main:gh-pages
```

### 其他部署方式

- **Netlify**: 连接 GitHub 仓库,自动构建部署
- **Vercel**: 导入项目,自动检测 Hugo 配置
- **自建服务器**: 上传 `public/` 目录到 Web 服务器

## 🔄 Jekyll 迁移

本博客从 Jekyll 迁移而来,使用 `migrate_jekyll_to_hugo.py` 脚本完成迁移:

```bash
# 安装依赖
pip install pyyaml

# 运行迁移
python migrate_jekyll_to_hugo.py
```

**迁移成果**:
- ✅ 31 篇文章完整迁移
- ✅ 62 张图片自动复制
- ✅ Front Matter 完整转换
- ✅ 图片路径自动更新

详细迁移文档: [walkthrough.md](.gemini/antigravity/brain/874e760b-41e8-4b2e-bba6-dda3c03ef769/walkthrough.md)

## 🧹 项目清理

### 为什么需要清理?

Hugo 构建时会生成静态文件到 `public/` 目录。如果在根目录发现 `posts/`、`tags/` 等目录,说明构建输出混入了源代码,需要清理。

### 执行清理

**方法 1: 使用清理脚本** (推荐)

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File cleanup.ps1
```

```bash
# Linux/macOS
bash cleanup.sh
```

**方法 2: 手动清理**

```bash
# 删除构建输出
rm -rf posts/ tags/ page/ index.html index.json index.xml sitemap.xml robots.txt 404.html

# 删除临时文件
rm -f update_date_format.py fix_date_format.py
```

### 验证清理结果

```bash
# 清理后重新构建
hugo --gc

# 检查 public 目录
ls public/

# 启动开发服务器
hugo server -D

# 访问 http://localhost:1313 验证功能
```

### 清理内容

清理脚本会删除:

**Hugo 构建输出**:
- `posts/`, `tags/`, `page/` 目录
- `index.html`, `index.json`, `index.xml`
- `sitemap.xml`, `robots.txt`, `404.html`

**临时脚本**:
- `update_date_format.py`
- `fix_date_format.py`

**示例文件**:
- `example-update.png`
- 示例文章目录

> **注意**: 原始文章和配置文件不会被删除

## 🛠️ 日常维护
- ✅ Front Matter 格式转换
- ✅ 图片路径自动更新

详细迁移文档: [walkthrough.md](.gemini/antigravity/brain/874e760b-41e8-4b2e-bba6-dda3c03ef769/walkthrough.md)

## 🛠️ 常用命令

### 快捷脚本

项目提供了多个快捷脚本:

| 脚本 | 平台 | 用途 |
|------|------|------|
| `create_post.bat` | Windows | 创建新文章 (最简单) |
| `create_post.ps1` | Windows | 创建新文章 (PowerShell) |
| `create_post.sh` | Linux/macOS | 创建新文章 (Bash) |
| `create_post.py` | 跨平台 | 创建新文章 (Python) |
| `cleanup.ps1` | Windows | 清理构建输出 |

### Hugo 命令

```bash
# 创建文章
hugo new posts/YYYY-MM-DD-title/index.md

# 本地预览 (含草稿)
hugo server -D

# 生产构建
hugo --minify

# 检查配置
hugo config

# 列出所有文章
hugo list all

# 清理缓存
hugo --gc
```

## 🎨 主题自定义

### 自定义样式

在 `assets/css/extended/` 创建 CSS 文件:

```css
/* assets/css/extended/custom.css */
:root {
    --primary: #your-color;
}
```

### 覆盖模板

复制主题文件到项目根目录对应位置即可覆盖。

## ❓ 常见问题

<details>
<summary>文章不显示?</summary>

- 检查 `draft: false` 是否设置
- 确认日期格式正确
- 运行 `hugo server -D` 查看草稿
</details>

<details>
<summary>图片无法显示?</summary>

- 确认图片在文章目录下
- 使用相对路径引用
- 检查文件名大小写
</details>

<details>
<summary>构建失败?</summary>

- 检查 YAML 格式
- 确认 Hugo 版本兼容性
- 查看错误日志
</details>

更多问题请查看 [FAQ 页面](content/faq/index.md)

## 📖 参考资源

- [Hugo 官方文档](https://gohugo.io/documentation/)
- [PaperMod 主题文档](https://github.com/adityatelange/hugo-PaperMod)
- [Hugo 快速开始](https://gohugo.io/getting-started/quick-start/)
- [Markdown 语法指南](https://www.markdownguide.org/)

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 🤝 贡献

欢迎提交 Issue 和 Pull Request!

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

---

**最后更新**: 2024-12-04  
**文章总数**: 31 篇  
**主题版本**: PaperMod v7.0

⭐ 如果这个项目对你有帮助,请给个 Star!
