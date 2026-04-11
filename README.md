# Ringi's Log

> 基于 Hugo + PaperMod 主题的技术博客,记录云计算、容器技术、OpenStack、Ceph 存储等领域的学习笔记与实践经验。

[![Hugo](https://img.shields.io/badge/Hugo-0.139.3-blue.svg)](https://gohugo.io)
[![Theme](https://img.shields.io/badge/Theme-PaperMod-green.svg)](https://github.com/adityatelange/hugo-PaperMod)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## 📚 博客内容

- 📚 **AI 技术**: LLM、Agent 智能体、RAG
- 🐳 **容器技术**: Docker、容器编排、镜像管理
- ☁️ **OpenStack**: 虚拟机管理、Cinder、Nova、Mistral 等组件
- 💾 **存储技术**: Ceph、RBD、分布式存储
- 🐧 **Linux 运维**: 网络工具、系统配置、性能优化
- 📊 **算法与编程**: 数据结构、算法实现

**文章统计**: 3\*\* 篇技术文章 (2023-2025)

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

## 📝 Obsidian 到博客迁移工具

### Obsidian to Blog Skill

使用 Claude Code 的 `obsidian-to-blog` skill 可以一键将 Obsidian Vault 中的文章迁移到博客。

**功能特性：**
- ✅ 自动转换 frontmatter 格式
- ✅ 下载并本地化文章图片到 `images/` 目录
- ✅ 转换 Wiki 链接为标准 Markdown 链接
- ✅ 智能扩展标签（clippings → AI相关、翻译等）
- ✅ 支持批量迁移
- ✅ 增量同步（跳过已迁移文件）
- ✅ 支持代码文件迁移
- ✅ SEO 增强（自动添加描述、原文引用）
- ✅ 迁移预览模式（dry-run）

**使用方式：**

在 Claude Code 中直接告诉它要迁移的文章：

```bash
# 迁移单个文章
帮我迁移这篇文章到博客：/Users/ringi/Documents/Obsidian Vault/Clippings/xxx.md

# 迁移 obsidian:// URL
帮我迁移这个 obsidian://open?vault=Obsidian%20Vault&file=Clippings/xxx.md

# 批量迁移
帮我批量迁移 Clippings 文件夹中的所有文章

# 预览模式（不实际写入）
预览迁移这个文章（dry-run）：/path/to/article.md
```

**迁移后的结构：**

```
content/posts/2026-04-11-文章标题/
├── index.md          ← 转换后的文章
└── images/          ← 下载的图片（相对路径引用）
    ├── image1.jpg
    └── image2.png
```

**图片处理：**
- 外部图片自动下载到文章的 `images/` 子目录
- Markdown 中的图片引用自动更新为相对路径
- 使用 md5(url) 重命名避免冲突

**标签转换示例：**

| Obsidian 标签 | 博客标签 |
|--------------|---------|
| clippings | AI相关, 翻译 |
| AI | AI相关 |
| 技术 | 技术 |

**配置文件：** `~/.claude/skills/obsidian-to-blog/config.json`

---

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
./create_post "Model Context Protocol(MCP) 编程极速入门" "GPU,LLM,AI,DeepLearning,Tutorial,AGI,幻觉,强化学习"
```

```
为这篇文章自动配图，一键完成全部流程，每个章节都要有配图：
文章: [替换为文章路径]
风格: [tech/sketch/elegant/minimal/warm/playful/nature/bold/notion]

要求：
1. 分析文章结构，识别所有章节
2. 为每个章节生成对应插图
3. 复制图片到文章的 imgs 目录
4. 更新文章，插入所有图片引用
5. 确保覆盖率 100%
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

# 图片说明 (推荐)

```markdown
<figure>
  <img src="image.png" alt="Instance-level contrastive learning">
  <figcaption>
    Figure 11: The training pipeline...  
    (Image source: <a href="https://arxiv.org/abs/1805.01978">Wu et al., 2018</a>)
  </figcaption>
</figure>
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

| 目录/文件    | 说明          | 是否提交到 Git |
| ------------ | ------------- | -------------- |
| `content/`   | 文章源文件    | ✅ 是          |
| `public/`    | Hugo 构建输出 | ❌ 否          |
| `resources/` | Hugo 资源缓存 | ❌ 否          |
| `themes/`    | Hugo 主题     | ✅ 是          |
| `hugo.yaml`  | Hugo 配置     | ✅ 是          |
| `.gitignore` | Git 忽略规则  | ✅ 是          |

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
baseURL: "https://lilinji.github.io/"
languageCode: "zh-cn"
title: "Ringi's Log"
theme: "PaperMod"

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
# 生成并最小化，启动服务器
hugo server -D --minify --gc
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
#git push -f git@github.com:lilinji/lilinji.github.io.git main:gh-pages
git push -f origin main
```

### 其他部署方式

- **Netlify**: 连接 GitHub 仓库,自动构建部署
- **Vercel**: 导入项目,自动检测 Hugo 配置
- **自建服务器**: 上传 `public/` 目录到 Web 服务器

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

**最后更新**: 2025-12-04  
**文章总数**: ** 篇  
**主题版本\*\*: PaperMod v7.0

⭐ 如果这个项目对你有帮助,请给个 Star!
