---
title: "如何找到下一个 100 倍创意：AI 痛点挖掘系统完整指南"
date: 2026-05-02T00:00:00+08:00
draft: false
tags:
  - AI相关
  - 创业
  - 产品
  - 方法论
author: Ringi Lee
showToc: true
tocOpen: false
description: "每个人想让 AI 给出一个 100 倍创意，但得到的都是垃圾。本文教你构建一套 AI 痛点挖掘系统，从真实对话中找到可验证的商业机会。"
slug: find-next-100x-idea
---

![Image](c7cb7009d397.jpg)

每个人都想让 AI 给出一个 100 倍创意，谁不想呢？他们去找 AI，问一堆问题，结果得到的全是垃圾。

别再浪费时间了，来搭这个吧。

是时候去猎寻痛点了。

真正的痛点。反复出现的痛点。昂贵的痛点。那种人们已经在抱怨、在搜索、在用 hack 方式绕过、甚至花钱买设计糟糕的工具来解决的痛点。

我们要搭建的是：

```markdown
社交监听告警
→ 数据库
→ AI 痛点提取
→ 机会评分
→ 手动 MVP
→ 构建 / 转型 / 放弃
```

这就是我们找到创意的方式，也可以用它来改进你现有的业务或想法。

我们要收集的数据是这样的社交信号：

- "我恨死手动做这件事了。"
- "有人知道这方面有什么工具吗？"
- "这个东西有替代品吗？"
- "太贵了。"
- "我还在用电子表格。"
- "每周在这上面浪费好几个小时。"
- "为什么这么难？"
- "我试了 X、Y、Z，还是很烂。"

这就是金矿所在。

## Reddit 和 X 的真相

Reddit 和 X 是这类研究的两个最佳来源。

但你需要小心。

Reddit 有用是因为人们会写长篇的、情绪化的抱怨。他们会解释他们的问题、变通方案、失败的工具、奇怪的边界情况，以及他们为什么烦。

X 有用是因为人们公开抱怨、请求推荐、比较工具，并实时揭示变化。

不要搞个破爬虫就说自己在做"AI 研究"。

- 尽可能使用官方 API。
- 在 API 混乱的地方使用经批准或授权的监控工具。
- 用告警，不要偷数据。
- 只存储你需要的。
- 遵守规则。

**AI 不会让糟糕的数据收集变得可以接受。**

![Image](b53fbe0d0717.jpg)

## 平台地图：我实际会用什么

**Reddit 适合：**

- 痛点挖掘
- 长篇抱怨
- 竞品替代品
- 小众社区
- "有人知道有什么工具吗？"这类帖子
- 用户的真实情绪化语言

Reddit 是了解人们在不被采访时如何表达的最佳场所之一。

这很重要。

**X 适合：**

- 实时抱怨
- 创始人/运营者的讨论
- 工具对比
- 市场变化
- 公开的购买意向
- 人们向社交网络寻求推荐

X 擅长速度，Reddit 擅长深度。

**YouTube 适合：**

- 创作者市场
- 教育产品
- 软件教程
- "怎么做 X？"这类行为
- 抱怨现有方案令人困惑的评论

当问题已经有教育需求时，YouTube 特别有用。

**Facebook 适合：**

- 没什么用哈哈，好吧，可能在群组里还行。

**LinkedIn 适合：**

- 手动搜索
- 内容
- 外展
- 访谈
- 关系驱动的验证

## 你将要构建什么？

你将构建一个 **AI 痛点挖掘机** 来寻找创意。

![Image](dbd5859a50ea.jpg)

它的工作：

1. 搜索 Reddit、X、YouTube、评论、论坛、博客和社交平台上的公开对话。
2. 将有用的提及拉入数据库。
3. 让 AI 提取痛点、变通方案、竞品、紧急程度和购买意向。
4. 对每个信号评分。
5. 将重复出现的问题归类为商业机会。
6. 将最强的机会转化为一个产品提案。
7. 用落地页、表单、外展或手动 MVP 来测试。

像这样：

```markdown
发现痛点
→ 评分痛点
→ 聚类痛点
→ 测试痛点
→ 只有人在乎才动手做
```

## 应该用什么工具？

```markdown
Brand24
Airtable
Make
OpenAI / ChatGPT API
Tally
Carrd, Framer, Lovable, Bolt, 或 v0
```

确保不要使用不靠谱的爬虫，确保使用官方 API 和经批准的工具。不要使用违反平台规则的爬虫。这不是个好主意。

Reddit 的数据 API 条款限制了用户内容的使用方式，包括未经许可使用 Reddit 内容训练 AI 模型，商业使用可能需要单独协议。

X 的 API 提供对公开对话的编程访问，但它现在使用按使用量计费的定价模式，需要预购积分，随着 API 请求的发出而扣除。

YouTube 对初学者更友好，因为它的数据 API 有官方评论端点。`commentThreads.list` 返回评论线程，每次调用消耗 1 个配额单位，YouTube 项目通常默认每日配额为 10,000 个单位。

## 最终你会得到什么：

一个仪表盘，显示：

```markdown
原始痛点信号
AI 摘要
痛点评分
买家细分
变通方案
竞品
重复痛点聚类
商业创意
落地页角度
手动 MVP 想法
构建 / 观望 / 忽略 判定
```

一份每周报告，像这样：

```markdown
本周最强机会：
独立招聘顾问浪费时间撰写候选人摘要。

证据：
来自 Reddit、X 和 YouTube 评论的 12 个强痛点信号。

最佳引言：
"我花好几个小时把杂乱的筛选笔记变成能实际发给客户的东西。"

推荐测试：
落地页 + 20 条招聘顾问私信 + 手动摘要服务。
```

# 阶段一：选择一个市场起步

不要一开始就覆盖所有市场，选一个。

示例：

```markdown
独立招聘顾问
房产中介
物理治疗师
加密货币研究员
Newsletter 作者
小型物业管理者
私人教练
电商运营者
YouTuber
独立咨询师
```

以及一个工作流：

```markdown
撰写客户摘要
创建每周报告
处理客户支持
管理租户维修
研究加密项目
撰写社交帖子
追发票
制定膳食计划
跟进销售线索
```

示例：

```text
买家：独立招聘顾问
工作流：将筛选电话笔记转化为客户就绪的候选人摘要
```

# 阶段二：创建你的 Airtable 数据库

打开 Airtable。

创建一个新数据库，命名为：AI Pain-Mining Machine（AI 痛点挖掘机）

创建以下表：

```text
1. 原始信号 (Raw Signals)
2. 痛点聚类 (Pain Clusters)
3. 商业创意 (Business Ideas)
4. 实验 (Experiments)
5. 客户访谈 (Customer Interviews)
6. 每周报告 (Weekly Reports)
```

## 表一：原始信号

每个 Reddit 帖子、X 帖子、YouTube 评论、评测、论坛评论或博客提及都放在这里。

创建以下字段：

```text
发现日期 (Date Found)
来源 (Source)
来源链接 (Source URL)
匹配关键词 (Keyword Matched)
原始文本 (Raw Text)
作者/账号 (Author / Handle)
买家细分 (Buyer Segment)
工作流 (Workflow)
精炼引言 (Clean Quote)
痛点 (Pain Point)
根本原因 (Root Cause)
当前变通方案 (Current Workaround)
提及竞品 (Competitor Mentioned)
购买意向信号 (Buying Intent Signal)
痛点严重度 /10 (Pain Severity /10)
紧急程度 /10 (Urgency /10)
频率 /10 (Frequency /10)
付费意愿 /10 (Willingness To Pay /10)
AI 自动化潜力 /10 (AI Automation Potential /10)
综合信号评分 /100 (Overall Signal Score /100)
信号质量 (Signal Quality)
状态 (Status)
人工审核 (Human Reviewed)
备注 (Notes)
```

**来源** 选项：

```text
Reddit
X
YouTube
TikTok
LinkedIn
Facebook
论坛
评测网站
博客
新闻
其他
```

**状态** 选项：

```text
新建 (New)
待 AI 处理 (Needs AI)
AI 已分析 (AI Analysed)
高信号 (High Signal)
低信号 (Low Signal)
已拒绝 (Rejected)
已聚类 (Clustered)
用于测试 (Used In Test)
```

**信号质量** 选项：

```text
低 (Low)
中 (Medium)
高 (High)
```

## 表二：痛点聚类

将重复出现的信号分组。

字段：

```text
聚类名称 (Cluster Name)
买家细分 (Buyer Segment)
工作流 (Workflow)
核心痛点 (Core Pain)
证据数量 (Evidence Count)
发现来源 (Sources Found)
最佳引言 (Best Quotes)
常见变通方案 (Common Workarounds)
提及竞品 (Competitors Mentioned)
平均信号评分 (Average Signal Score)
机会评分 /100 (Opportunity Score /100)
手动 MVP 想法 (Manual MVP Idea)
落地页角度 (Landing Page Angle)
判定 (Verdict)
备注 (Notes)
```

判定选项：

```text
构建测试 (Build Test)
观望 (Watch)
忽略 (Ignore)
需要更多研究 (Needs More Research)
```

## 表三：商业创意

字段：

```text
创意名称 (Idea Name)
买家 (Buyer)
解决的问题 (Problem Solved)
产品提案 (Offer)
手动 MVP 版本 (Manual MVP Version)
后续软件版本 (Software Version Later)
定价假设 (Pricing Hypothesis)
分发渠道 (Distribution Channel)
主要风险 (Main Risk)
机会评分 /100 (Opportunity Score /100)
状态 (Status)
```

状态选项：

```text
创意 (Idea)
测试中 (Testing)
已验证 (Validated)
已放弃 (Killed)
已转型 (Pivoted)
```

## 表四：实验

字段：

```text
实验名称 (Experiment Name)
商业创意 (Business Idea)
落地页链接 (Landing Page URL)
表单链接 (Form URL)
行动号召 (CTA)
流量来源 (Traffic Source)
访客数 (Visitors)
注册数 (Signups)
表单完成数 (Form Completions)
预约通话数 (Booked Calls)
手动 MVP 试用数 (Manual MVP Trials)
付费试点数 (Paid Pilots)
转化备注 (Conversion Notes)
判定 (Verdict)
```

## 表五：客户访谈

字段：

```text
姓名 (Name)
角色 (Role)
公司 (Company)
邮箱 (Email)
买家细分 (Buyer Segment)
问题已确认? (Problem Confirmed?)
当前变通方案 (Current Workaround)
痛点等级 /10 (Pain Level /10)
预算证据 (Budget Evidence)
愿意试手动 MVP? (Would Try Manual MVP?)
愿意付费? (Would Pay?)
最佳引言 (Best Quote)
需要跟进? (Follow-Up Needed?)
备注 (Notes)
```

## 表六：每周报告

字段：

```text
周起始日 (Week Starting)
头号痛点聚类 (Top Pain Cluster)
最佳机会 (Best Opportunity)
关键证据 (Key Evidence)
推荐测试 (Recommended Test)
构建/观望/忽略判定 (Build / Watch / Ignore Verdict)
报告文本 (Report Text)
```

# 阶段三：设置你的社交监听工具

打开 Brand24 或其他社交监听工具。

创建一个新项目。

命名为：Recruiter Pain Mining（招聘痛点挖掘）

或者你正在研究的任何市场。

你的目标是收集人们抱怨该工作流的公开提及。

## 添加关键词

从 10 到 20 个关键词开始。

以招聘为例：

```text
"candidate summary"
"candidate summaries"
"screening call notes"
"recruiter notes"
"recruiter admin"
"recruitment CRM too expensive"
"alternative to recruitment CRM"
"recruiter spreadsheet"
"client-ready candidate summary"
"recruiter notes to client"
"recruiter manual admin"
"recruitment admin takes too long"
```

你要找的是揭示痛点的短语。

更好的搜索："candidate summaries" "takes hours"

更差的搜索："recruiting"

## 添加痛点修饰词

创建另一个关键词组，包含以下短语：

```text
"takes hours"
"manual"
"frustrating"
"annoying"
"too expensive"
"alternative to"
"does anyone know a tool"
"how do you manage"
"spreadsheet"
"copy paste"
"wasting time"
```

最好的搜索组合是：买家 + 工作流 + 痛点修饰词

示例："recruiter" "candidate summaries" "takes hours"

## 设置来源过滤器

从这些来源开始：

```text
Reddit
X
YouTube
论坛
评测
博客
新闻
```

LinkedIn、Facebook 和私密社区要"谨慎使用"。它们可能有用，但从权限和信号质量角度来看更混乱。

# 阶段四：将提及导入 Airtable

你有三个选项。从选项 A 开始，然后转向 B 或 C。

## 选项 A：手动导出

先用这个。

每天一次：

1. 打开 Brand24。
2. 进入你的提及信息流。
3. 过滤相关来源。
4. 打开每条有用的提及。
5. 复制有用的文本。
6. 粘贴到 Airtable 的 **原始信号** 表。
7. 将状态设为"待 AI 处理"。

## 选项 B：邮件告警导入 Airtable

当你确认关键词效果不错后使用。

设置：

```text
Brand24 告警邮件
→ Gmail
→ Make
→ Airtable 原始信号
```

在 Gmail 中：

1. 创建一个标签叫"痛点信号"。
2. 为你的 Brand24 告警邮件创建过滤器。
3. 自动应用"痛点信号"标签。

在 Make 中：

1. 创建一个新场景。
2. 添加 Gmail 作为触发器。
3. 选择"监控邮件"。
4. 过滤标签为"痛点信号"。
5. 添加 Airtable。
6. 选择"创建记录"。
7. 选择你的数据库：AI Pain-Mining Machine。
8. 选择你的表：Raw Signals。
9. 将邮件主题/正文映射到 Airtable 字段。
10. 将状态设为"待 AI 处理"。

这样你就有了一个可工作的自动化收集器。

## 选项 C：API / Webhook 收集

后续再用。

高级路径：

```text
Brand24 API 或 webhook
→ Make webhook
→ Airtable
```

或者：

```text
Reddit API
X API
YouTube API
→ Make / n8n / 自定义脚本
→ Airtable
```

除非你理解你想要的数据，否则不要从这里开始。

API 版本更强大，但逻辑是一样的。

# 阶段五：构建 AI 分析自动化

现在让 AI 分析每个信号。

在 Airtable 的 **原始信号** 中创建一个视图，命名为："待 AI 处理"

过滤条件：状态 = 待 AI 处理 (Needs AI)

打开 Make。

创建一个新场景：

```text
Airtable 监控记录
→ OpenAI 生成响应
→ Airtable 更新记录
```

Make 的 Airtable 模块可以监控视图中新建或更新的记录，它的 OpenAI 模块可以根据提示词生成响应。

## Make 步骤一：Airtable 触发器

模块：Airtable > 监控记录 (Watch Records)

选择：

```text
数据库：AI Pain-Mining Machine
表：Raw Signals
视图：Needs AI
```

这意味着 Make 会监控需要分析的信号。

## Make 步骤二：OpenAI 分析

粘贴这个提示词：

```markdown
你正在分析公开的客户对话以发现创业机会。

你的工作是从下面的文本中提取商业痛点。

重要规则：
- 不要编造证据。
- 只使用文本中出现的内容。
- 如果文本模糊，给低分。
- 忽略泛泛的闲聊。
- 优先关注具体的工作流痛点、购买意向、丑陋的变通方案、竞品不满、紧急程度和付费意愿的证据。
- 除非必要，不要包含个人数据。
- 引言要简短。

使用以下格式返回输出：

买家细分 (Buyer Segment)：
工作流 (Workflow)：
精炼引言 (Clean Quote)：
痛点 (Pain Point)：
根本原因 (Root Cause)：
当前变通方案 (Current Workaround)：
提及竞品 (Competitor Mentioned)：
购买意向信号 (Buying Intent Signal)：
痛点严重度 /10 (Pain Severity /10)：
紧急程度 /10 (Urgency /10)：
频率 /10 (Frequency /10)：
付费意愿 /10 (Willingness To Pay /10)：
AI 自动化潜力 /10 (AI Automation Potential /10)：
综合信号评分 /100 (Overall Signal Score /100)：
信号质量 (Signal Quality)：
推荐状态 (Recommended Status)：
备注 (Notes)：

评分指南：
- 0 到 30 = 弱信号
- 31 到 60 = 可能的信号
- 61 到 80 = 强信号
- 81 到 100 = 优秀信号

原始文本：
{{Raw Text}}
```

将 {{Raw Text}} 替换为上一步的 Airtable 字段。

## Make 步骤三：更新 Airtable

更新同一条记录。

将 AI 输出映射到字段。

如果一开始觉得解析每个字段太难，可以这样做：

在 Airtable 创建一个长文本字段叫：AI 分析

然后把完整的 AI 输出放在那里。

# 阶段六：人工审核

不要让 AI 做最终决定。

创建一个 Airtable 视图，命名为："待人工审核"

过滤条件：

```text
状态 = AI 已分析 (AI Analysed)
综合信号评分 > 60
人工审核 = 未勾选
```

每天审核这个视图。

问自己：

```text
买家清晰吗？
痛点具体吗？
变通方案丑陋吗？
有购买意向吗？
这个问题可能会反复出现吗？
我能手动解决吗？
AI 能改进这个流程吗？
```

然后设置：

```text
人工审核 = 已勾选
状态 = 高信号 或 低信号 或 已拒绝
```

这是你的判断力发挥作用的地方。

AI 能挖掘。

你决定什么是金子。

# 阶段七：每周聚类痛点

当你有了 30 到 100 个高信号后，将它们分组。

创建一个视图叫："本周高信号"

过滤条件：

```text
状态 = 高信号 (High Signal)
发现日期 = 过去 7 天内
```

将这些记录复制到 ChatGPT，或者后续在 Make 中自动化。

使用这个提示词：

```markdown
你是一位创业研究分析师。

我给你高质量的客户痛点信号。

你的工作是将它们聚类为重复出现的商业机会。

不要编造任何东西。
只使用提供的证据。

对每个聚类，返回：

1. 聚类名称
2. 买家细分
3. 工作流
4. 核心痛点
5. 证据数量
6. 最佳客户引言
7. 当前变通方案
8. 提及的竞品
9. 现有方案为何不足
10. 紧急程度
11. 付费意愿证据
12. 手动 MVP 想法
13. 落地页测试想法
14. 机会评分（满分 100）
15. 判定：构建测试 / 观望 / 忽略

以下是信号：

[粘贴信号]
```

然后在 **痛点聚类** 表中创建记录。

# 阶段八：为每个机会评分

使用这个评分系统。

```text
数量和重复度：20
痛点严重度：20
紧急程度：10
变通方案丑陋度：10
买家意向：10
与现有工具的差距：15
变现可行性：10
构建可行性：5
```

然后应用扣分：

```text
重大法律/平台风险：-15
买家身份模糊：-10
分发渠道薄弱：-10
纯炒作趋势：-10
```

使用这个提示词：

```text
你是我残酷诚实的创业机会评分器。

为这个痛点聚类打分（满分 100）。

使用这个评分模型：

- 数量和重复度：20
- 痛点严重度：20
- 紧急程度：10
- 变通方案丑陋度：10
- 买家意向：10
- 与现有工具的差距：15
- 变现可行性：10
- 构建可行性：5

应用扣分：
- 重大法律或平台风险：-15
- 买家身份模糊：-10
- 分发渠道薄弱：-10
- 纯炒作趋势，证据薄弱：-10

输出：

1. 总分
2. 为什么是这个分数
3. 支持该分数的证据
4. 反对该分数的证据
5. 最大的假设
6. 手动 MVP 版本
7. 落地页测试
8. 推荐下一步
9. 判定：构建测试 / 观望 / 忽略

痛点聚类：

[粘贴痛点聚类]
```

只测试评分 **70 分以上** 的聚类。

低于 70 分的进入观察列表。

# 阶段九：将一个聚类转化为商业创意

选一个强聚类。

不要选五个。

使用这个提示词：

```text
你是一位定位策略师。

将这个痛点聚类转化为 10 个精准的商业提案。

痛点聚类：
[粘贴聚类]

客户引言：
[粘贴引言]

当前变通方案：
[粘贴变通方案]

竞品或替代品：
[粘贴竞品]

使用这个格式：

我帮助 [具体买家] 实现 [具体成果]，无需 [痛苦的事情]，通过使用 [新机制]。

每个提案包括：
- 买家
- 成果
- 消除的痛点
- 新机制
- 为什么可能有效
- 弱点

然后选择最强的提案。

规则：
- 要具体。
- 避免炒作。
- 避免使用优化、简化、赋能、转型、革命性等模糊词汇。
- 使用客户的语言。
```

# 阶段十：创建落地页测试

不要先做产品。

先做测试页。

使用 Carrd、Framer、Lovable、Bolt、v0 或 Webflow。

落地页结构：

```text
首屏 (Hero)
问题要点
适用人群
旧方式 vs 新方式
工作原理
手动内测 / 早期访问 CTA
验证表单
常见问题
```

使用这个提示词：

```text
为这个验证测试创建落地页文案。

目标买家：
[插入买家]

问题：
[插入问题]

客户引言：
[插入引言]

当前变通方案：
[插入变通方案]

产品提案：
[插入提案]

主要 CTA：
申请手动内测

规则：
- 诚实说明这是早期访问或手动内测。
- 使用客户语言。
- 不要使用虚假推荐。
- 不要做没有依据的声明。
- 保持清晰、具体、以转化为导向。
- 避免炒作词汇。

包含：

1. 首屏标题
2. 副标题
3. CTA 按钮文案
4. 痛点要点
5. 适用人群
6. 旧方式 vs 新方式
7. 工作原理
8. 你能得到什么
9. 常见问题
10. 最终 CTA
11. 验证表单问题
```

# 阶段十一：创建验证表单

使用 Tally。

表单不应该只收集邮箱。

要问能证明痛点的问题。

问题：

```text
最能描述你的是？
你现在如何解决这个问题？
这个问题多久发生一次？
最烦人的是哪部分？
每周在这上面花多少时间？
你试过什么工具吗？
那些工具没解决什么？
你愿意试手动内测吗？
如果能解决这个问题，你愿意付费吗？
你愿意接受 15 分钟通话吗？
邮箱地址
```

# 阶段十二：手动引流

这是大多数人逃避的地方。

你需要真实的人。

发送 20 到 50 条消息。

使用 LinkedIn、X、Reddit、你的社交网络或小众社区。

# 阶段十三：后续添加直接 API

系统运转后再添加直接 API。

这是我推荐的添加顺序。

**YouTube API**

用它来拉取你细分领域视频的评论。

**X API**

当你需要更好的实时社交痛点时使用。

**Reddit API**

在 subreddit 中搜索问题短语。

拉取帖子标题和评论。

不要用 Reddit 内容训练模型。

遵守删除/商业使用规则。

## 你已经搭好了！！！

**没人想听的部分：**

这个系统不会消除对品味的需求。

它不会消除判断力。

它不会消除销售。

它不会消除客户对话。

## 核心要点：

每个人都试图把 AI 当成创意机器。

那是弱版本。

更强的版本是把 AI 当成痛点雷达。

重要的是：

- **不要让 AI 随机生成创业创意**。搭建一个从真实对话中发现重复客户痛点的系统。
- **不要像小偷一样爬数据**。使用官方 API、经批准的监控工具和干净的收集方法。
- **不要只从抱怨出发**。为机会评分，测试落地页，与买家交谈，先卖手动版本。

## 现在就去找到那个 100 倍创意！！！

---

> 原文作者：[@hooeem](https://x.com/hooeem)
> 原文地址：[https://x.com/hooeem/status/2050332284675362853](https://x.com/hooeem/status/2050332284675362853)
