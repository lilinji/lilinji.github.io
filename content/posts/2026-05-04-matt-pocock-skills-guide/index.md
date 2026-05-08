---
title: "Matt Pocock Skills 使用指南：给真正写代码的工程师"
date: 2026-05-04T00:00:00+08:00
draft: false
tags:
  - AI相关
  - Claude Code
  - 工具
  - 工程实践
author: Ringi Lee
showToc: true
tocOpen: false
source: "https://github.com/mattpocock/skills"
---

Matt Pocock（TypeScript 大师、Total TypeScript 创始人）开源了一套 Claude Code skill，目标很明确：**让 AI 像真正的工程师一样写代码，而不是"vibe coding"**。

这套 skill 不是什么花哨的自动化流水线，而是把几十年的工程经验压缩成了可重复的工作流。每个 skill 都很小、很容易改、可以自由组合。

## 安装

```bash
npx skills@latest add mattpocock/skills
```

安装时会问你选择哪些 skill、安装到哪些 coding agent 上。**务必选中 `/setup-matt-pocock-skills`**——它是其他工程 skill 的配置入口。

安装完成后，在 Claude Code 中运行：

```
/setup-matt-pocock-skills
```

它会问你三个问题：

1. **Issue Tracker**：你用什么管理 issue？（GitHub / GitLab / 本地文件 / 其他）
2. **Triage Labels**：你给 issue 打什么标签做分类？（默认值一般够用）
3. **Domain Docs**：你的领域文档放哪里？（单上下文 / 多上下文 monorepo）

配置完成后，其他 skill 就知道去哪找 issue、怎么读你的项目术语了。

## 核心 Skill 一览

### 工程类（Engineering）

| Skill | 命令 | 用途 |
|-------|------|------|
| **grill-me** | `/grill-me` | 对你的方案进行无情追问，直到每个决策分支都清晰 |
| **grill-with-docs** | `/grill-with-docs` | 同上，但会同时更新 CONTEXT.md 和 ADR 文档 |
| **diagnose** | `/diagnose` | 结构化 debug 循环：复现 → 最小化 → 假设 → 插桩 → 修复 → 回归测试 |
| **tdd** | `/tdd` | 红-绿-重构循环，一个垂直切片一个垂直切片地写 |
| **to-prd** | `/to-prd` | 把当前对话上下文合成 PRD，发布到 issue tracker |
| **to-issues** | `/to-issues` | 把 PRD / 计划拆成独立可抓取的 issue（垂直切片） |
| **triage** | `/triage` | 通过状态机对 issue 进行分类流转 |
| **improve-codebase-architecture** | `/improve-codebase-architecture` | 找到代码库中"变深"的机会，改善架构 |
| **zoom-out** | `/zoom-out` | 让 agent 拉远视角，解释某段代码在系统中的位置 |
| **setup-matt-pocock-skills** | `/setup-matt-pocock-skills` | 每个仓库运行一次，配置 issue tracker 和领域文档 |

### 效率类（Productivity）

| Skill | 命令 | 用途 |
|-------|------|------|
| **caveman** | `/caveman` | 穴居人模式：砍掉 75% 的废话，只保留技术干货 |
| **grill-me** | `/grill-me` | 非代码场景的追问（方案设计、架构决策等） |
| **write-a-skill** | `/write-a-skill` | 创建新 skill，带正确的结构和渐进式信息展示 |

### 辅助类（Misc）

| Skill | 命令 | 用途 |
|-------|------|------|
| **git-guardrails-claude-code** | `/git-guardrails-claude-code` | 设置 Claude Code hooks，拦截危险 git 命令 |

## 推荐工作流

### 1. 开始新功能之前

```
/grill-with-docs
```

这是 Matt 最推荐的 skill。它不只是问你想要什么，还会：

- 挑战你的方案是否与现有领域模型一致
- 当你用的术语和 CONTEXT.md 冲突时立刻指出
- 把模糊的概念精确化（"你说的 account 是 Customer 还是 User？"）
- 用具体场景压测你的设计
- 交叉验证代码和你的描述是否一致
- 每解决一个术语就更新 CONTEXT.md

**效果**：agent 的输出会从"说了 20 个词其实 1 个词就够"变成精准的表达。这不只是省 token——变量名、函数名、文件名都会跟着一致起来。

### 2. 拆解任务

```
/to-prd    → 生成 PRD 并发布到 issue tracker
/to-issues → 把 PRD 拆成垂直切片的 issue
```

`/to-prd` 不会再问你问题——它直接从对话上下文中合成 PRD。包含：问题描述、解决方案、用户故事列表、实现决策、测试决策、范围外事项。

`/to-issues` 把 PRD 拆成"tracer bullet"式的 issue。每个 issue 是一个贯穿所有层的垂直切片（schema → API → UI → 测试），而不是横切某一层。有两种类型：

- **AFK**：agent 可以独立完成，不需要人参与
- **HITL**：需要人做决策（架构选择、设计审查等）

### 3. 写代码

```
/tdd
```

关键原则：**一次写一个测试，一次写一个实现**。不要"先把所有测试写完再写代码"（那是水平切片，会产生垃圾测试）。

```
正确（垂直切片）：
  RED→GREEN: test1 → impl1
  RED→GREEN: test2 → impl2
  RED→GREEN: test3 → impl3

错误（水平切片）：
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5
```

好的测试只通过公共接口验证行为，不关心内部实现。重构时测试不应该挂。

### 4. Debug

```
/diagnose
```

结构化的 debug 循环，六个阶段：

1. **建反馈循环**——这是核心。没有快速、确定性的 pass/fail 信号，盯着代码看是没用的
2. **复现**——确认 bug 确实是用户描述的那个
3. **假设**——生成 3-5 个可证伪的假设，按可能性排序
4. **插桩**——每个探针对应一个假设，一次只改一个变量
5. **修复 + 回归测试**——先写回归测试，再修 bug
6. **清理 + 复盘**——删除调试代码，问"什么能防止这个 bug 发生？"

### 5. 节省 token

```
/caveman
```

穴居人模式。砍掉所有废话，只保留技术内容。效果：

```
普通模式："Sure! I'd be happy to help you with that. The issue you're experiencing is likely caused by..."

穴居人模式："Bug in auth middleware. Token expiry check use `<` not `<=`. Fix:"
```

用 `stop caveman` 或 `normal mode` 退出。

### 6. 代码库维护

```
/improve-codebase-architecture
```

每隔几天跑一次。它会找到代码库中可以"变深"的机会——用简单的接口封装更多功能，而不是到处都是浅层的 wrapper。

## 设计哲学

Matt 的核心观点：

1. **Agent 没做你想做的事** → 用 `/grill-*` 在开始前对齐
2. **Agent 废话太多** → 建立共享语言（CONTEXT.md），让 agent 用项目的术语
3. **代码不工作** → 红-绿-重构循环 + 静态类型 + 浏览器访问
4. **代码变成了泥球** → 关心设计，用 `/improve-codebase-architecture` 定期清理

> 软件工程基础比以往任何时候都重要。这些 skill 是我将这些基础压缩成可重复实践的最佳尝试。

## 与其他 Skill 的关系

这套 skill 和其他常见 skill 集的区别：

- **不控制你的流程**：不像 GSD、BMAD、Spec-Kit 那样接管整个开发流程，而是提供可插拔的工具
- **小而可组合**：每个 skill 只做一件事，可以自由搭配
- **基于工程经验**：来自 Matt 多年的 TypeScript 和工程实践，不是理论堆砌

## 快速参考卡

```
开始新功能：  /grill-with-docs
拆任务：      /to-prd → /to-issues
写代码：      /tdd
Debug：       /diagnose
省 token：    /caveman
维护架构：    /improve-codebase-architecture
拉远视角：    /zoom-out
Issue 分类：  /triage
创建新 skill：/write-a-skill
Git 安全：    /git-guardrails-claude-code
```
