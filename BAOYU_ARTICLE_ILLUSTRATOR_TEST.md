# Baoyu Article Illustrator 技能测试演示

**技能名称**: baoyu-article-illustrator  
**安装时间**: 2026-01-16 09:20  
**技能来源**: https://github.com/JimLiu/baoyu-skills  
**作者**: Jim Liu (@JimLiu)

---

## 🎨 技能简介

**Smart Article Illustration Skill** - 智能文章配图技能

自动分析文章结构和内容，识别需要视觉辅助的位置，并生成符合风格的插图。

---

## ✨ 核心功能

### 1. 自动风格选择

根据文章内容自动选择最合适的插图风格

### 2. 9 种插图风格

| 风格                 | 特点               | 适用场景            |
| -------------------- | ------------------ | ------------------- |
| **1. elegant**       | 精致、专业、高雅   | 商业文章、专业内容  |
| **2. tech**          | 现代、科技、数字化 | AI、编程、技术文章  |
| **3. warm**          | 温暖、友好、人性化 | 个人成长、生活方式  |
| **4. bold**          | 高对比、有冲击力   | 观点文章、重要警告  |
| **5. minimal**       | 极简、禅意、专注   | 哲学、极简主义      |
| **6. playful**       | 有趣、创意、俏皮   | 教程、初学者指南    |
| **7. nature**        | 有机、平静、自然   | 可持续发展、健康    |
| **8. sketch**        | 原始、手绘、笔记风 | 头脑风暴、思考过程  |
| **9. notion** (默认) | 简约线条艺术       | 知识分享、SaaS 内容 |

### 3. 智能插图定位

自动识别文章中需要视觉辅助的位置：

- 抽象概念需要可视化
- 流程/步骤需要图解
- 对比需要视觉呈现
- 核心论点需要强化

---

## 📋 使用方法

### 基本用法

```bash
# 自动选择风格
/baoyu-article-illustrator path/to/article.md

# 指定风格
/baoyu-article-illustrator path/to/article.md --style tech
/baoyu-article-illustrator path/to/article.md --style warm
/baoyu-article-illustrator path/to/article.md --style minimal
```

### 风格选择指南

技能会根据以下信号自动选择风格：

| 内容信号                         | 自动选择风格 |
| -------------------------------- | ------------ |
| AI、编程、技术、数字、算法、数据 | `tech`       |
| 个人故事、情感、成长、生活       | `warm`       |
| 警告、紧急、必读、重要           | `bold`       |
| 简单、禅意、专注、核心           | `minimal`    |
| 有趣、简单、初学者、教程         | `playful`    |
| 自然、生态、健康、有机           | `nature`     |
| 想法、思考、概念、草稿           | `sketch`     |
| 商业、专业、策略、分析           | `elegant`    |
| 知识、概念、生产力、SaaS         | `notion`     |

---

## 🧪 测试演示

### 测试文章选择

我将使用您的 Hugo 博客文章进行测试演示：

**测试文章**: `2025-AI-Engineering-Reading-List论文`  
**文章路径**: `d:\lilinji.github.io\content\posts\2026-01-14-2025-AI-Engineering-Reading-List论文\index.md`

### 演示步骤

让我为这篇 AI 工程阅读清单文章添加插图：

#### Step 1: 分析文章内容

```markdown
文章主题: AI Engineering Reading List (AI 工程阅读清单)
预期风格: tech (因为包含 AI、engineering、技术等关键词)
```

#### Step 2: 识别插图位置

根据文章结构，可能需要插图的位置：

1. **文章开头** - 总览图，展示 AI 工程全景
2. **各个论文部分** - 为每个重要论文创建概念图
3. **技术栈部分** - 可视化技术架构
4. **总结部分** - 学习路径图

#### Step 3: 技能工作流程

```
1. 读取文章 ✓
2. 分析内容和选择风格 (自动选择 tech 风格)
3. 识别插图位置 (至少 3-5 个位置)
4. 生成插图计划
5. 创建提示词文件到 imgs/prompts/
6. 调用图片生成 API
7. 将图片插入文章
8. 输出完成摘要
```

#### Step 4: 生成的文件结构

```
d:\lilinji.github.io\content\posts\2026-01-14-2025-AI-Engineering-Reading-List论文\
├── index.md (原文章，会被更新)
└── imgs/
    ├── outline.md (插图规划)
    ├── prompts/
    │   ├── illustration-ai-engineering-overview.md
    │   ├── illustration-llm-architecture.md
    │   ├── illustration-paper-concepts.md
    │   └── ...
    ├── illustration-ai-engineering-overview.png
    ├── illustration-llm-architecture.png
    ├── illustration-paper-concepts.png
    └── ...
```

---

## 🎨 风格示例

### Tech 风格特征

```yaml
Colors:
  Primary: Deep blue (#1A365D)
  Accent: Electric cyan (#00D4FF)
  Secondary: Purple (#6B46C1)
  Background: Dark gray (#1A202C)
  Highlights: Neon green (#00FF88), bright white

Elements:
  - Circuit patterns
  - Data nodes
  - Geometric grids
  - Glowing effects
  - Tech icons
  - Code snippets
  - Neural network patterns
```

### 示例提示词

```markdown
Illustration theme: AI Engineering Landscape
Style: tech

Visual composition:

- Main visual: Neural network nodes connected in a geometric grid
- Layout: Centered focal point with radiating connections
- Decorative elements: Circuit patterns, glowing data streams

Color scheme:

- Primary: Deep blue (#1A365D)
- Background: Dark gray (#1A202C)
- Accent: Electric cyan (#00D4FF)

Text content (if any):

- AI Engineering (英文标题)
- LLMs, Agents, RAG (关键概念标签)

Style notes: Modern tech aesthetic with glowing effects and geometric precision
```

---

## 💡 实际使用示例

### 示例 1: 为技术博客添加插图

```bash
# 自动选择风格（会选择 tech）
/baoyu-article-illustrator d:\lilinji.github.io\content\posts\2026-01-14-2025-AI-Engineering-Reading-List论文\index.md
```

预期输出：

```
Article Illustration Complete!

Article: d:\lilinji.github.io\content\posts\2026-01-14-2025-AI-Engineering-Reading-List论文\index.md
Style: tech
Generated: 5/5 images successful

Illustration Positions:
- illustration-ai-engineering-overview.png → After introduction section
- illustration-llm-fundamentals.png → After "LLM Fundamentals" section
- illustration-agent-patterns.png → After "Agent Patterns" section
- illustration-rag-architecture.png → After "RAG Systems" section
- illustration-learning-roadmap.png → After conclusion section
```

### 示例 2: 为教程文章添加插图

```bash
# 指定 playful 风格
/baoyu-article-illustrator path/to/beginner-guide.md --style playful
```

### 示例 3: 为产品文档添加插图

```bash
# 指定 minimal 风格
/baoyu-article-illustrator path/to/product-docs.md --style minimal
```

---

## 🔍 技能工作流详解

### 1. 内容分析与风格选择

- 读取文章内容
- 扫描风格信号关键词
- 自动选择或使用指定风格
- 提取主题和核心信息

### 2. 插图位置识别

根据三个目的识别位置：

1. **信息补充**: 帮助理解抽象概念
2. **概念可视化**: 将抽象思想转化为具象
3. **想象引导**: 营造氛围，增强阅读体验

### 3. 生成插图计划

创建详细的插图规划文档

### 4. 创建提示词文件

为每张图片生成专业的图像生成提示词

### 5. 生成图片

调用图像生成 API（需要配置）

### 6. 更新文章

自动插入图片到合适位置

### 7. 输出摘要

报告生成结果和位置

---

## ⚙️ 技能配置

### 前置要求

1. **图像生成 API**: 需要配置以下之一

   - DALL-E API
   - Midjourney API
   - Stable Diffusion
   - 魔塔社区
   - 其他图像生成服务

2. **环境变量** (可能需要):
   我的魔塔社区的 key =ms-4066b0b2-89c9-44d9-ac95-b13b9295bbf9
   ```bash
   export OPENAI_API_KEY="ms-4066b0b2-89c9-44d9-ac95-b13b9295bbf9"
   # 或其他图像生成服务的 API key
   ```

---

## 📊 技能特点

### 优势

✅ **智能分析**: 自动识别需要插图的位置  
✅ **风格丰富**: 9 种专业设计的风格  
✅ **自动化**: 从分析到生成一键完成  
✅ **一致性**: 同一篇文章保持风格统一  
✅ **灵活性**: 支持自动和手动风格选择

### 限制

⚠️ **需要 API**: 需要配置图像生成 API  
⚠️ **生成时间**: 每张图片需要 10-30 秒  
⚠️ **成本**: 图像生成可能产生 API 费用

---

## 🎯 最佳实践

### 1. 选择合适的风格

- 技术文章 → `tech`
- 教程指南 → `playful`
- 专业内容 → `elegant`
- 概念讲解 → `notion`

### 2. 插图密度

- 长文章（3000 字+）: 5-8 张插图
- 中等文章（1500 字）: 3-5 张插图
- 短文章（500 字）: 1-2 张插图

### 3. 位置优化

- 开头：总览性插图
- 各大章节：概念性插图
- 结尾：总结性插图

---

## 📝 技能文件

**SKILL.md 路径**:

```
C:\Users\lilinji\.gemini\antigravity\skills\baoyu-article-illustrator\SKILL.md
```

**技能大小**: 329 行，10.7 KB

---

## 🌟 示例用例

### 用例 1: AI 技术博客

**文章**: "深入理解 Transformer 架构"  
**风格**: tech  
**插图**:

- Transformer 架构总览
- Self-Attention 机制图
- Multi-Head Attention 可视化
- Position Encoding 示意图

### 用例 2: 个人成长文章

**文章**: "如何培养良好的学习习惯"  
**风格**: warm  
**插图**:

- 学习环境设置
- 时间管理流程
- 进步曲线图
- 成就里程碑

### 用例 3: 产品设计文档

**文章**: "极简设计原则"  
**风格**: minimal  
**插图**:

- 核心设计原则
- 留白的力量
- 视觉层次结构

---

## ✅ 下一步

1. **配置图像生成 API** (如果还没有)
2. **选择测试文章**
3. **运行技能测试**
4. **查看生成结果**
5. **根据需要调整风格**

---

**安装完成！** 🎉

技能已准备就绪，可以开始为您的文章添加精美插图了！

---

**创建时间**: 2026-01-16 09:20  
**文档版本**: 1.0  
**技能状态**: ✅ 已安装并就绪
