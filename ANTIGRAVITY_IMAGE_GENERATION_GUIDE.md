# Antigravity 图像生成与内容创作 Skills 完全指南

**更新时间**: 2026-01-20
**文档版本**: 2.0
**推荐级别**: ⭐⭐⭐⭐⭐

---

## 🎉 Skills 概览

Antigravity 内置强大的图像生成功能（Google Gemini Imagen），配合 lilinji-\* 系列 skills，可实现**一键式内容创作**！

### 已安装 lilinji Skills（10个）

| Skill                            | 描述                         | 触发词                     |
| -------------------------------- | ---------------------------- | -------------------------- |
| **lilinji-article-illustrator**  | 文章配图生成器（20种风格）   | 生成插图、配图、illustrate |
| **lilinji-slide-deck**           | 幻灯片生成器（16种风格）     | 生成幻灯片、PPT、slides    |
| **lilinji-comic**                | 知识漫画创作器（9种风格）    | 生成漫画、comic、知识漫画  |
| **lilinji-cover-image**          | 文章封面图生成器（19种风格） | 生成封面、cover image      |
| **lilinji-xhs-images**           | 小红书图片生成器（9种风格）  | 小红书、XHS、RedNote       |
| **lilinji-compress-image**       | 图片压缩工具                 | 压缩图片、compress         |
| **lilinji-post-to-wechat**       | 发布到微信公众号             | 发布公众号、post to wechat |
| **lilinji-post-to-x**            | 发布到 X/Twitter             | 发布推特、post to X        |
| **lilinji-danger-gemini-web**    | 抓取网页内容                 | 抓取网页、fetch URL        |
| **lilinji-danger-x-to-markdown** | X/Twitter 转 Markdown        | X转markdown                |

---

## 🖼️ 图像生成类 Skills

### 1. lilinji-article-illustrator

为文章自动生成配图。

```bash
# 基本用法 - 自动选择风格
/lilinji-article-illustrator path/to/article.md

# 指定风格
/lilinji-article-illustrator article.md --style tech
/lilinji-article-illustrator article.md --style pixel-art
/lilinji-article-illustrator article.md --style sketch-notes
```

**支持的 20 种风格**：
`elegant` `tech` `warm` `bold` `minimal` `playful` `nature` `sketch` `notion` `watercolor` `vintage` `scientific` `chalkboard` `editorial` `flat` `retro` `blueprint` `vector-illustration` `sketch-notes` `pixel-art`

---

### 2. lilinji-slide-deck

从文章生成专业幻灯片。

```bash
# 基本用法
/lilinji-slide-deck article.md

# 指定风格和受众
/lilinji-slide-deck article.md --style corporate
/lilinji-slide-deck article.md --audience executives

# 仅生成大纲
/lilinji-slide-deck article.md --outline-only

# 指定语言
/lilinji-slide-deck article.md --lang zh
```

**支持的 16 种风格**：

| 风格               | 描述            | 适用场景           |
| ------------------ | --------------- | ------------------ |
| `blueprint`        | 技术蓝图风格    | 架构设计、系统设计 |
| `notion`           | SaaS 仪表盘美学 | 产品演示、B2B      |
| `bold-editorial`   | 杂志社论风格    | 产品发布、主题演讲 |
| `corporate`        | 海军蓝/金色配色 | 投资者演示、提案   |
| `dark-atmospheric` | 电影级暗色调    | 娱乐、游戏         |
| `minimal`          | 极简风格        | 高管简报           |
| `pixel-art`        | 8-bit 像素风    | 游戏、开发者       |
| `sketch-notes`     | 手绘风格        | 教育、教程         |
| ...                | ...             | ...                |

---

### 3. lilinji-comic

创作知识漫画。

```bash
# 基本用法
/lilinji-comic story.md

# 指定风格
/lilinji-comic story.md --style ohmsha
/lilinji-comic story.md --style realistic
/lilinji-comic story.md --style wuxia

# 指定布局和比例
/lilinji-comic story.md --layout cinematic --aspect 16:9
```

**支持的 9 种风格**：

| 风格        | 描述             | 适用场景         |
| ----------- | ---------------- | ---------------- |
| `classic`   | 传统清线风格     | 传记、教育       |
| `dramatic`  | 高对比度，重阴影 | 重大发现、冲突   |
| `warm`      | 柔和边缘、金色调 | 个人故事、师生情 |
| `sepia`     | 复古插画风格     | 1950前故事、历史 |
| `vibrant`   | 富有活力         | 科学解说、青少年 |
| `ohmsha`    | 欧姆社漫画风格   | 技术教程、ML教学 |
| `realistic` | 全彩写实日漫     | 美食、商业       |
| `wuxia`     | 港漫武侠风格     | 武侠、仙侠       |
| `shoujo`    | 少女漫画风格     | 恋爱、青春       |

**布局选项**：`standard` `cinematic` `dense` `splash` `mixed` `webtoon`

---

### 4. lilinji-cover-image

生成文章封面图。

```bash
# 自动选择风格
/lilinji-cover-image article.md

# 指定风格
/lilinji-cover-image article.md --style blueprint
/lilinji-cover-image article.md --style dark-atmospheric

# 无标题封面
/lilinji-cover-image article.md --no-title

# 指定比例
/lilinji-cover-image article.md --aspect 16:9
```

**支持的 19 种风格**：
`elegant` `flat-doodle` `blueprint` `bold-editorial` `chalkboard` `dark-atmospheric` `editorial-infographic` `fantasy-animation` `intuition-machine` `minimal` `nature` `notion` `pixel-art` `playful` `retro` `sketch-notes` `vector-illustration` `vintage` `warm` `watercolor`

---

### 5. lilinji-xhs-images

生成小红书风格图片系列。

```bash
# 自动选择风格
/lilinji-xhs-images content.md

# 指定风格和布局
/lilinji-xhs-images content.md --style notion --layout dense

# 指定风格
/lilinji-xhs-images content.md --style tech
```

**支持的 9 种风格**：
`cute` `fresh` `tech` `warm` `bold` `minimal` `retro` `pop` `notion`

**布局选项**：`sparse` `balanced` `dense` `list` `comparison` `flow`

---

## 🛠️ 工具类 Skills

### 6. lilinji-compress-image

压缩图片以优化加载速度。

```bash
/lilinji-compress-image images/
/lilinji-compress-image article/imgs/
```

---

### 7. lilinji-post-to-wechat

将 Markdown 文章发布到微信公众号。

```bash
/lilinji-post-to-wechat article.md
```

**前置条件**：需要配置微信公众号 API 凭证。

---

### 8. lilinji-post-to-x

发布内容到 X/Twitter。

```bash
/lilinji-post-to-x content.md
```

---

## 🌐 数据抓取类 Skills

### 9. lilinji-danger-gemini-web

抓取网页内容并转换为 Markdown。

```bash
/lilinji-danger-gemini-web https://example.com/article
```

⚠️ **注意**：此 skill 名称包含 "danger" 表示可能涉及敏感操作，请谨慎使用。

---

### 10. lilinji-danger-x-to-markdown

将 X/Twitter 帖子转换为 Markdown 格式。

```bash
/lilinji-danger-x-to-markdown https://x.com/user/status/123456
```

---

## 🚀 快速开始工作流

### 文章配图完整流程

```bash
# Step 1: 为文章生成配图
/lilinji-article-illustrator article.md --style tech

# Step 2: 查看生成的大纲
cat imgs/outline.md

# Step 3: 图片已自动生成并插入文章
```

### 幻灯片制作流程

```bash
# Step 1: 生成大纲预览
/lilinji-slide-deck article.md --outline-only

# Step 2: 确认后生成完整幻灯片
/lilinji-slide-deck article.md --style notion --lang zh
```

### 小红书图片流程

```bash
# Step 1: 生成小红书风格图片系列
/lilinji-xhs-images content.md --style notion --layout dense
```

---

## 💡 提示词优化技巧

### 1. 使用详细描述

```
Modern tech illustration with neural network at center,
surrounded by glowing nodes in deep blue (#1A365D) and
electric cyan (#00D4FF). Dark background with circuit texture.
```

### 2. 明确指定颜色（带色值）

```
配色方案:
- 主色: Deep blue (#1A365D)
- 背景: Dark gray (#1A202C)
- 点缀: Electric cyan (#00D4FF)
```

### 3. 描述布局和构图

```
Visual composition:
- Main visual: Neural network at center
- Layout: Radial expanding from center
- Connections: Glowing data flow lines
```

---

## 📊 风格对比速查

| 需求         | 推荐 Skill                  | 推荐风格           |
| ------------ | --------------------------- | ------------------ |
| 技术文章配图 | lilinji-article-illustrator | tech, blueprint    |
| 个人博客配图 | lilinji-article-illustrator | warm, sketch-notes |
| 投资者演示   | lilinji-slide-deck          | corporate          |
| 技术分享     | lilinji-slide-deck          | notion, blueprint  |
| 知识科普漫画 | lilinji-comic               | ohmsha             |
| 人物传记漫画 | lilinji-comic               | classic, sepia     |
| 小红书干货   | lilinji-xhs-images          | tech, notion       |
| 小红书种草   | lilinji-xhs-images          | cute, fresh        |
| 文章封面     | lilinji-cover-image         | bold-editorial     |

---

## 📁 Skill 文件位置

所有 skills 安装在：

```
C:\Users\lilinji\.gemini\antigravity\skills\
├── lilinji-article-illustrator/
├── lilinji-slide-deck/
├── lilinji-comic/
├── lilinji-cover-image/
├── lilinji-xhs-images/
├── lilinji-compress-image/
├── lilinji-post-to-wechat/
├── lilinji-post-to-x/
├── lilinji-danger-gemini-web/
└── lilinji-danger-x-to-markdown/
```

---

## ❓ 常见问题

### Q1: Skill 触发词是什么？

直接使用 `/lilinji-<skill-name>` 或自然语言描述需求，Antigravity 会自动识别。

### Q2: 如何查看生成的图片？

图片自动显示在对话中，并保存在 `brain/<conversation-id>/` 目录。

### Q3: 可以自定义风格吗？

可以！大部分 skills 支持自然语言描述自定义风格：

```bash
/lilinji-comic story.md --style "水彩风格，边缘柔和"
```

### Q4: 生成失败怎么办？

1. 检查提示词是否清晰
2. 尝试简化描述
3. 重新生成

---

**更新时间**: 2026-01-20
**文档版本**: 2.0
**Skill 来源**: 基于 [baoyu-skills](https://github.com/JimLiu/baoyu-skills) 定制
