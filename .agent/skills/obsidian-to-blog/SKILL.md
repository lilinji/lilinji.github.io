---
name: obsidian-to-blog
description: 将 Obsidian Clippings/笔记发布为 Hugo 博客文章。自动转换 frontmatter、处理图片链接、创建标准目录结构。使用方式："发布 Obsidian 文章到博客" 或提供 obsidian:// URL。
---

# Obsidian to Hugo Blog Skill

将 Obsidian vault 中的文章（Clippings 或笔记）转换并发布为 Hugo 博客文章。

## 触发条件

当用户提到以下任意内容时使用此 skill：
- "发布 Obsidian 文章到博客"
- "obsidian to blog"
- "从 Obsidian 发博客"
- 提供 `obsidian://` URL
- "把这篇笔记发到博客"

## 配置

| 配置项 | 值 |
|--------|-----|
| Obsidian Vault 路径 | `D:\Obsidian\lilinji` |
| Hugo 博客根目录 | `D:\lilinji.github.io` |
| 文章目录 | `content/posts/` |
| 作者 | `Ringi Lee` |
| 默认标签 | 用户指定，常见：`AI相关` |

## 执行流程

### Step 1: 解析输入

从用户输入中提取以下信息：

1. **文章路径**：
   - 如果是 `obsidian://` URL，解码得到文件路径
     - 格式：`obsidian://open?vault=lilinji&file=Clippings%2F文章名`
     - 解码后：`D:\Obsidian\lilinji\Clippings\文章名.md`
   - 如果是文件名，在 vault 中搜索
   - 如果是完整路径，直接使用

2. **标签**：用户指定的标签（如 "AI相关"）

3. **Draft 状态**：默认 `false`（直接发布），用户可指定 `draft: true`

### Step 2: 读取 Obsidian 文章

使用 `view_file` 读取源文章内容。

Obsidian 文章典型 frontmatter：
```yaml
---
title: "文章标题"
source: "https://原文链接"
author:
  - "[[@作者名]]"
published: 2026-04-06
created: 2026-04-08
description: "文章描述..."
tags:
  - "clippings"
---
```

### Step 3: 转换 Frontmatter

将 Obsidian frontmatter 转换为 Hugo PaperMod 格式：

```yaml
---
title: "文章标题"          # 保持不变
date: 2026-04-08T09:00:00+08:00  # 使用当前时间，ISO 8601 格式
draft: false               # 默认发布
tags:                       # 使用用户指定的标签
  - AI相关
author: Ringi Lee           # 固定作者
showToc: true               # 显示目录
tocOpen: false              # 目录默认收起
---
```

**转换规则：**

| Obsidian 字段 | Hugo 字段 | 处理方式 |
|---------------|-----------|----------|
| `title` | `title` | 保持不变 |
| `source` | 正文添加原文来源 | 转为 `> 原文来源：[链接](URL)` |
| `author` | 正文可选添加作者 | 清理 `[[@xxx]]` 格式 |
| `published` | 参考 | 可用于 `date` |
| `created` | 忽略 | 使用当前时间 |
| `description` | 可选 `summary` | 如需要可添加 |
| `tags: clippings` | 替换 | 使用用户指定标签 |

### Step 4: 处理正文内容

1. **图片处理**：
   - **URL 图片**（如 `![Image](https://pbs.twimg.com/...)`）→ **保持不变**
   - **本地图片**（如 `![](image.jpg)`）→ 复制图片到博客文章目录，保持相对引用
   - **Obsidian 内部链接图片**（如 `![[image.png]]`）→ 转换为标准 markdown `![](image.png)` 并复制文件

2. **Obsidian 语法清理**：
   - `[[@username]]` → `@username` 或保持为文本
   - `[[内部链接]]` → 纯文本或移除双括号
   - `==高亮==` → `**高亮**`（Hugo 不支持 ==）
   - 移除 Obsidian 特有的 callout 语法差异（Hugo 使用 `>` blockquote）

3. **代码块**：保持不变

4. **描述中的 blockquote**：如果 Obsidian description 长，可作为文章开头引用块

### Step 5: 创建 Hugo 文章目录和文件

1. **目录命名**：`YYYY-MM-DD-slug`
   - 日期：当前日期
   - Slug：标题去除特殊字符，空格替换为 `-`
   
2. **文件**：`content/posts/YYYY-MM-DD-slug/index.md`

3. **本地图片**：如有，复制到同目录下

```
content/posts/2026-04-08-搞懂缓存机制从Gemma4到Claude-Code省80Token/
├── index.md
└── (可选的本地图片文件)
```

### Step 6: 验证

运行以下命令验证文章可以正确渲染：

```powershell
# 在博客根目录执行
hugo server -D
```

检查项：
- [ ] frontmatter 格式正确
- [ ] 图片正常显示
- [ ] 目录（ToC）正常生成
- [ ] 代码块语法高亮正确
- [ ] 标签显示正确

## Slug 生成规则

```
输入标题: "搞懂缓存机制，从Gemma4到Claude Code省80%Token"
处理步骤:
1. 移除标点符号（，。！？；：""''）
2. 空格替换为 -
3. 保留中文、英文、数字、-
4. 多个连续 - 合并为一个
5. 去掉首尾 -

输出 slug: "搞懂缓存机制从Gemma4到Claude-Code省80Token"
```

## 示例

### 用户输入
```
obsidian://open?vault=lilinji&file=Clippings%2F搞懂缓存机制...  
标签 AI相关
```

### 执行结果
```
✅ 文章已创建: content/posts/2026-04-08-搞懂缓存机制从Gemma4到Claude-Code省80Token/index.md
   标题: 搞懂缓存机制，从Gemma4到Claude Code省80%Token
   标签: AI相关
   图片: 3 张（URL，保持不变）
   
下一步:
1. hugo server -D 预览
2. 确认后 deploy
```

## 注意事项

1. **编码**：所有文件使用 UTF-8 without BOM
2. **日期格式**：Hugo 要求 ISO 8601（`2026-04-08T09:00:00+08:00`）
3. **标题中的特殊字符**：frontmatter 中标题需要引号包裹
4. **图片 URL 中的 &**：Hugo markdown 中 `&` 不需要转义
5. **Obsidian 双链**：Hugo 不支持 `[[]]` 语法，必须转换
