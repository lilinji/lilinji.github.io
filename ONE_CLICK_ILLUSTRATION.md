# 🚀 一键文章配图自动化工具

**版本**: 1.0  
**更新时间**: 2026-01-16

---

## ⭐ 一键完成 Prompt 模板

复制以下 prompt 到 Antigravity，替换文章路径即可一键完成所有工作：

### 🎯 万能 Prompt（复制即用）

```
请为以下文章自动配图，完成全部流程：

文章路径: [替换为你的文章路径，例如: d:\lilinji.github.io\content\posts\my-article\index.md]
风格: auto (或指定: tech / elegant / warm / minimal / playful / nature / sketch / notion / bold)

请执行以下完整流程：
1. 读取并分析文章内容，识别主题和关键概念
2. 自动选择合适的视觉风格（或使用我指定的风格）
3. 识别 3-5 个需要插图的关键位置
4. 为每个位置创建图片提示词
5. 使用 generate_image 工具生成所有图片
6. 将生成的图片复制到文章的 imgs 目录
7. 更新文章，在正确位置插入图片引用
8. 输出完成报告

一键完成，无需我额外操作。
```

---

## 🎨 按风格的快捷 Prompt

### Tech 风格（技术文章）

```
为这篇技术文章自动配图:
路径: d:\lilinji.github.io\content\posts\[文章目录]\index.md
风格: tech

自动完成：分析文章 → 生成提示词 → 生成5张插图 → 复制到imgs目录 → 更新文章
```

### Elegant 风格（商业/专业）

```
为这篇商业文章自动配图:
路径: d:\lilinji.github.io\content\posts\[文章目录]\index.md
风格: elegant

自动完成全部流程，包括生成图片和更新文章。
```

### Playful 风格（教程/入门）

```
为这篇教程自动配图:
路径: d:\lilinji.github.io\content\posts\[文章目录]\index.md
风格: playful

一键完成所有配图工作。
```

### Minimal 风格（极简/设计）

```
为这篇文章配图:
路径: d:\lilinji.github.io\content\posts\[文章目录]\index.md
风格: minimal

自动完成全流程。
```

---

## 📋 完整版 Prompt（带详细控制）

```
# 文章自动配图任务

## 基本信息
- 文章路径: d:\lilinji.github.io\content\posts\[文章目录]\index.md
- 风格偏好: auto 或 [tech/elegant/warm/minimal/playful/nature/sketch/notion/bold]
- 插图数量: 自动 或 [3-8]

## 执行要求

### 阶段 1: 分析
1. 读取文章内容
2. 提取主题、关键概念、章节结构
3. 确定最佳视觉风格

### 阶段 2: 规划
1. 识别需要插图的位置（优先选择：抽象概念、流程步骤、核心论点）
2. 为每个位置创建插图描述
3. 生成详细的图片提示词

### 阶段 3: 生成
1. 创建 imgs 和 imgs/prompts 目录
2. 保存提示词文件
3. 使用 generate_image 工具生成所有图片

### 阶段 4: 整合
1. 将生成的图片复制到文章的 imgs 目录
2. 使用规范的文件名（illustration-概念名.png）
3. 在文章中插入图片引用 ![描述](imgs/文件名.png)

### 阶段 5: 报告
输出完成报告，包含：
- 生成的图片列表
- 插入位置
- 最终文章预览

## 一键执行
无需确认，直接开始执行全部流程。
```

---

## 🔥 超简版 Prompt（最懒人版）

### 版本 1: 最简单

```
为这篇文章自动配图并更新文章:
路径: [你的文章路径]
```

### 版本 2: 带风格

```
tech风格，自动配图:
[你的文章路径]
```

### 版本 3: 批量处理

```
为以下所有文章自动配图（tech风格）:
1. d:\lilinji.github.io\content\posts\article-1\index.md
2. d:\lilinji.github.io\content\posts\article-2\index.md
3. d:\lilinji.github.io\content\posts\article-3\index.md

逐个完成，每篇生成3-5张插图。
```

---

## 📝 示例：实际使用

### 示例 1

您输入：

```
为这篇文章自动配图:
d:\lilinji.github.io\content\posts\2026-01-16-收录官方与社区共建资源的-Claude-Skills-精选合集\index.md
风格: tech
```

Antigravity 自动完成：

1. ✅ 读取文章
2. ✅ 识别主题（Claude Skills, AI, Tech）
3. ✅ 选择 tech 风格
4. ✅ 识别 5 个插图位置
5. ✅ 生成 5 个提示词
6. ✅ 生成 5 张图片
7. ✅ 复制到 imgs 目录
8. ✅ 更新文章
9. ✅ 输出报告

### 示例 2

您输入：

```
playful风格自动配图:
d:\lilinji.github.io\content\posts\python-beginner-guide\index.md
```

结果：

- 5 张可爱俏皮风格的插图
- 自动插入文章
- 完成！

---

## 🎛️ 高级控制选项

### 控制插图数量

```
为文章配图，要求：
- 路径: [路径]
- 风格: tech
- 数量: 只要3张，分别在：开头、中间、结尾
```

### 控制图片主题

```
为文章配图：
- 路径: [路径]
- 风格: tech
- 图片主题要求：
  1. 第一张: 总览性banner图
  2. 第二张: 流程图
  3. 第三张: 架构图
  4. 第四张: 对比图
  5. 第五张: 总结图
```

### 控制配色

```
为文章配图：
- 路径: [路径]
- 风格: tech
- 品牌色: 使用 #0066CC 作为主色调
```

### 不更新文章（只生成）

```
为文章生成配图（不修改文章）：
- 路径: [路径]
- 只生成图片和提示词到 imgs 目录
- 不要修改 index.md
```

---

## 💾 保存为工作流（可选）

### 创建工作流文件

在 `.agent/workflows/` 目录创建：

**文件路径**: `d:\lilinji.github.io\.agent\workflows\auto-illustrate.md`

```markdown
---
description: 一键为文章自动配图
---

# 自动配图工作流

// turbo-all

## Step 1: 接收参数

用户提供文章路径和可选的风格参数

## Step 2: 分析文章

读取文章，提取主题和关键概念

## Step 3: 选择风格

根据内容自动选择或使用用户指定的风格

## Step 4: 识别插图位置

找出 3-5 个需要视觉辅助的位置

## Step 5: 生成提示词

为每个位置创建详细的图片提示词

## Step 6: 生成图片

使用 generate_image 工具生成所有图片

## Step 7: 复制图片

将图片复制到文章的 imgs 目录

## Step 8: 更新文章

在正确位置插入图片引用

## Step 9: 输出报告

显示完成摘要
```

使用时：

```
/auto-illustrate d:\lilinji.github.io\content\posts\my-article\index.md --style tech
```

---

## 📊 流程图

```
┌─────────────────┐
│  输入 Prompt    │
│  (文章路径+风格) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  读取文章内容   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  分析主题/风格  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  识别插图位置   │
│  (3-5 个位置)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  生成提示词文件 │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  generate_image │
│  (生成所有图片) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  复制到 imgs/   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  更新文章       │
│  (插入图片引用) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  输出完成报告   │
└─────────────────┘

总耗时: 约 2-5 分钟（取决于图片数量）
```

---

## ✅ 使用清单

使用前确认：

- [x] Antigravity 已打开
- [x] 文章已存在（Markdown 格式）
- [x] 文章路径正确
- [x] 知道想要的风格（或让 AI 自动选择）

使用方法：

1. 复制上面的 Prompt 模板
2. 替换文章路径
3. 可选：修改风格
4. 粘贴到 Antigravity
5. 等待完成！

---

## 🎉 现在就试试！

复制这段 prompt，替换路径，然后发送给 Antigravity：

```
为这篇文章自动配图:
d:\lilinji.github.io\content\posts\[你的文章目录]\index.md
风格: tech

一键完成所有流程：分析 → 生成提示词 → 生成图片 → 更新文章
```

**就这么简单！** 🚀

---

**创建时间**: 2026-01-16  
**工具**: Antigravity + generate_image + baoyu-article-illustrator
