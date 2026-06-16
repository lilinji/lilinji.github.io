---
title: "重读 DDD：领域驱动设计不是写 class 的规矩 | 战略到战术完整入门"
date: 2026-06-16T00:00:00+08:00
draft: true
tags:
  - DDD
  - 领域驱动设计
  - 软件架构
  - 战略模式
  - 战术模式
author: Ringi Lee
showToc: true
tocOpen: false
---

# 《重读 DDD：领域驱动设计不是写 class 的规矩》大纲

> 总字数：12000-14500 中文字 ｜ Hugo 单篇 ｜ TypeScript 示例 ｜ Mermaid 图 ｜ 2026-06 月发布
>
> 文件名：`_outline.md`（下划线前缀让 Hugo 忽略渲染，作为工作草稿保留在 post 目录内）
>
> 配套待写文件：`index.md`（文章本体）

---

## 整体结构

| # | 章节 | 字数 | 形式 | 核心论点 |
| --- | --- | --- | --- | --- |
| 0 | 标题 + 副标题 + 导语 | 200 | 文字 | 反直觉钩子 |
| 1 | 开头：DDD 不是关于代码的 | 800 | 散文 | 破除"DDD = OO 设计"迷思 |
| 2 | DDD 的世界观：为什么复杂软件需要它 | 1500 | 散文 + 1 个失败案例 | 复杂度的真正来源是语言不一致，不是 class |
| 3 | 战略模式（DDD 的真正价值） | 4500 | 散文 + 3 张 Mermaid 图 | 切分是核心问题，class 写法是次要问题 |
| 4 | 战术模式（在切分好之后怎么建模） | 4500 | 散文 + 3 段 TS 代码 + 1 张 Mermaid 类图 | 战术是手段、战略是目的 |
| 5 | 怎么开始用 DDD | 1500 | 散文 + 1 个小型 Example Mapping 案例 | 启动仪式比"理解概念"更重要 |
| 6 | 什么时候不该用 DDD | 1200 | 散文 + 4 个红色信号清单 | 入门文章最高 ROI 的祛魅 |
| 7 | 延伸阅读：先读哪本 | 500 | 清单 | Distilled → IDDD → Evans |
| 8 | 结尾 | 500 | 散文 | 把 DDD 当"工具箱"而不是"教条" |
|   | **合计** | **~13000** |   |   |

---

## §0 标题 + 副标题 + 导语（200 字）

**主标题**：`重读 DDD`
**副标题**：`领域驱动设计不是写 class 的规矩 | 战略到战术完整入门`

**导语（出现在 Hugo frontmatter `description` 字段、社交分享卡、目录上方）**：
> 大多数人把 DDD 当作"OO 写法的升级版"——Entity、ValueObject、Repository 这套战术模式。但 Eric Evans 写那本蓝皮书时，70% 篇幅在讲团队协作和语言对齐。本文重新梳理 DDD 的战略与战术，让你理解：DDD 真正解决的不是"class 怎么画"，而是"领域应该怎么切、团队应该怎么对话"。

---

## §1 开头：DDD 不是关于代码的（800 字）

**核心论点**：很多人觉得 DDD 是"OO 写法的规矩 + repository 模式"，但 Eric Evans 2003 年写那本蓝皮书时，**70% 篇幅在讲团队协作和语言对齐**，只有 30% 在讲 class。这是反直觉的。

**开头方式**：
> 如果你以为 DDD 是关于怎么写 class 的——那你这篇文章读对了。我曾经也这么以为，花了半年时间把项目里的 Entity / ValueObject / Repository 模式都搬上去，结果业务越复杂，代码越乱。后来才发现，DDD 的真正价值不在战术模式，而在战略层。

**反直觉的钉子**：把"DDD = class 设计"这个迷思钉在开头第一段。

**本节要埋的伏笔**：
- "DDD 的真正价值在战略层"——为 §3 做铺垫
- "战术模式搬上去但业务越复杂越乱"——为 §4 引出"战术不是不重要，而是顺序错了"

---

## §2 DDD 的世界观：为什么复杂软件需要它（1500 字）

**核心论点**：复杂业务系统的真正敌人不是"代码不够 OO"，而是"团队说一套话、代码说另一套话"。

**叙事结构**：
1. **失败案例**（400 字）：某 SaaS 系统初期一切顺利，第 6 个月开始，"客户"在产品文档里指 A（潜在购买者），在销售嘴里指 B（已签单的企业），在数据库里指 C（账户实体），团队开始互相听不懂。技术讨论变成"你说的客户是哪个客户？"的循环。
2. **Eric Evans 的洞察**（600 字）：软件的目的是让领域专家和开发者用同一门语言描述业务。Evans 2003 年提 DDD 时，第一条原则就是"通用语言（Ubiquitous Language）"。
3. **"通用语言"是起点**（500 字）：通用语言要落到代码命名（class 名、变量名、commit message）。如果领域专家说的词在代码里找不到，那这个语言就不通用。

**反衬**：这一节末尾埋一句"具体怎么让代码说人话？怎么在大型系统里保持这种一致性？我们下两节讲。"为 §3 §4 铺垫。

---

## §3 战略模式（4500 字）

**核心论点**：DDD 的真正价值在战略层——回答"业务应该怎么切、团队应该怎么协作"。

### §3.1 通用语言 Ubiquitous Language（1000 字）

- 业务专家和开发者共同维护的"领域词汇表"
- 反例：产品文档里的"订单状态" ≠ 数据库里的 `order_status` ≠ UI 上的"已完成"——3 个语言在同一个系统里同时存在
- 落点：通用语言要落到代码命名（class 名、变量名、commit message）
- 关键洞察：**通用语言不是文档，是代码本身**。文档会过时，代码不会骗人。

### §3.2 限界上下文 Bounded Context（1200 字）

- "同一个词在不同上下文里有不同含义"是普遍现象
- 限界上下文 = 通用语言 + 模型 + 代码 的边界
- 例子：电商系统中，"商品"在库存上下文是 SKU + 数量，在营销上下文是商品名 + 优惠标签，在订单上下文是商品快照
- **【Mermaid 图 1】**：一个电商系统的限界上下文划分（订单、库存、会员、支付、营销 5 个框 + 依赖箭头）

### §3.3 上下文地图 Context Map（1200 字）

- 限界上下文之间如何协作
- 关键模式：
  - **Shared Kernel**（共享内核）：两个上下文共用一部分模型
  - **Customer/Supplier**（客户-供应商）：上游下游明确
  - **Conformist**（顺从者）：下游直接接受上游模型
  - **Anti-Corruption Layer**（防腐层）：下游用翻译层保护自己
  - **Open Host Service**（开放主机）：上游用稳定的协议对外
- **【Mermaid 图 2】**：一个上下文地图示例，标出每个边界的关系类型

### §3.4 子域 Subdomain（1100 字）

- 业务不是"一个整块"，而是分**核心子域（Core）**、**支撑子域（Supporting）**、**通用子域（Generic）**
- 核心子域 = 公司的核心竞争力（电商的推荐算法、Uber 的派单逻辑）
- 支撑子域 = 围绕核心的必要能力（电商的订单管理、Uber 的司机认证）
- 通用子域 = 不分行业都一样的（邮件发送、支付网关）
- **【Mermaid 图 3】**：蛋糕图 / 三层同心圆——核心域在中间，支撑在外，通用在最外
- 关键洞察：**核心域要自己做**（不是买现成的），通用域可以外包

---

## §4 战术模式（4500 字）

**核心论点**：战略告诉我们"在哪切一刀"，战术告诉我们"切完之后这一刀内部怎么建模"。

### §4.1 实体 Entity（1300 字）

- **定义**：有唯一标识、生命周期中状态可变、ID 不变
- TS 示例：一个 User entity，ID 用 branded type 表达
- **关键规则**：
  - 用 ID 判断相等，不靠字段值
  - 实体行为内聚在自己身上（不是贫血模型）
  - ID 类型用 branded type（`type UserId = string & { __brand: 'UserId' }`）避免 primitive obsession
- **反模式**：getter/setter 全暴露 = 贫血模型
- **【TS 代码块 1】**：~30 行 User entity

```typescript
// 草稿占位 — 实际写稿时填充
type UserId = string & { readonly __brand: 'UserId' };

class User {
  private constructor(
    private readonly id: UserId,
    private name: string,
    private email: Email,
  ) {}

  static create(id: UserId, name: string, email: Email): User {
    return new User(id, name, email);
  }

  changeName(newName: string): void {
    if (!newName) throw new Error('姓名不能为空');
    this.name = newName;
  }

  equals(other: User): boolean {
    return this.id === other.id;
  }
}
```

### §4.2 值对象 Value Object（1300 字）

- **定义**：无标识、不可变、相等靠值
- TS 示例：一个 Money 值对象（amount + currency），用 `readonly` + 工厂方法保证不可变
- **关键洞察**：值对象 = 把"小概念"提取出来避免 primitive obsession
- 经典例子：`Money(amount, currency)` 比 `let amount: number; let currency: string` 安全——避免出现"日元金额 + 美元币种"的荒谬
- **【TS 代码块 2】**：~30 行 Money + Address 值对象

```typescript
// 草稿占位 — 实际写稿时填充
class Money {
  private constructor(
    private readonly amount: number,
    private readonly currency: string,
  ) {
    if (amount < 0) throw new Error('金额不能为负');
  }

  static of(amount: number, currency: string): Money {
    return new Money(amount, currency);
  }

  add(other: Money): Money {
    if (this.currency !== other.currency) {
      throw new Error('币种不同，不能相加');
    }
    return new Money(this.amount + other.amount, this.currency);
  }

  equals(other: Money): boolean {
    return this.amount === other.amount && this.currency === other.currency;
  }
}
```

### §4.3 聚合 Aggregate / Aggregate Root（1900 字）

- **定义**：一组必须保持强一致性的实体 + 值对象的集合，由聚合根统一管理
- **关键规则**：
  - 不变量（invariant）必须在事务内由聚合根保证
  - 外部只能通过聚合根修改聚合内部对象
  - 一个事务只修改一个聚合
- **反例**：Order 跨聚合修改 OrderItem + Inventory 导致数据不一致——应该用领域事件（domain event）异步通知库存上下文
- **【TS 代码块 3】**：~50 行 Order 聚合（含 OrderItem 值对象 + 业务方法）
- **【Mermaid 图 4】**：Order 聚合的内部结构（聚合根 + 实体 + 值对象）

```typescript
// 草稿占位 — 实际写稿时填充
class Order {
  private constructor(
    private readonly id: OrderId,
    private readonly customerId: CustomerId,
    private readonly items: OrderItem[],
    private status: OrderStatus,
  ) {}

  static place(customerId: CustomerId, items: OrderItem[]): Order {
    if (items.length === 0) throw new Error('订单必须至少有一个商品');
    return new Order(OrderId.generate(), customerId, items, OrderStatus.Pending);
  }

  addItem(item: OrderItem): void {
    if (this.status !== OrderStatus.Pending) {
      throw new Error('只有待支付订单可以加商品');
    }
    this.items.push(item);
  }

  pay(): void {
    if (this.status !== OrderStatus.Pending) {
      throw new Error('订单当前状态不能支付');
    }
    this.status = OrderStatus.Paid;
  }

  totalAmount(): Money {
    return this.items
      .map(i => i.subtotal())
      .reduce((acc, m) => acc.add(m), Money.of(0, 'CNY'));
  }
}
```

---

## §5 怎么开始用 DDD（1500 字）

**核心论点**：DDD 是"团队工作方式"的改变，不是"个人技术升级"。

启动仪式三选一：

### §5.1 Event Storming（450 字）

- Alberto Brandolini 提出的工作坊方法
- 全员（业务 + 开发）用便利贴把**领域事件**（domain event）按时间线贴出来
- 从右往左追溯命令（command）、聚合（aggregate）、外部系统
- **优点**：最有现场感、团队对齐效果最好
- **缺点**：需要 4-8 人、3-4 小时集中工作坊，远程团队难做；中文圈实践案例少

### §5.2 Example Mapping（500 字）

- Matt Wynne 提出的小型化方法
- 把每个用户故事拆成：
  - **Story**（黄色卡）：用户故事
  - **Rule**（蓝色卡）：业务规则
  - **Example**（绿色卡）：规则的例子
  - **Question**（红色卡）：还没搞清楚的疑问
- **【小型案例】**：用一个"用户注册"的用户故事演示 Example Mapping 怎么用（约 200 字 + 简单清单）

```
Story: 用户可以用邮箱注册账号
  Rule: 邮箱必须唯一
    Example: 同一邮箱第二次注册时返回"邮箱已存在"
  Rule: 密码至少 8 位
    Example: 7 位密码注册失败
  Question: 注册成功后是否自动登录？
```

### §5.3 Domain Storytelling（300 字）

- 用时序图画出"人 + 系统 + 业务对象"之间的交互
- 优点：跨业务/技术沟通效果最好
- 缺点：需要会画 DSL

### §5.4 我的推荐：Example Mapping 作为入门首选（250 字）

理由：
- 4 人以下
- 独立开发者也能用
- 远程友好（在线白板即可）
- 一次 30-60 分钟就能跑完一个用户故事

---

## §6 什么时候不该用 DDD（1200 字）

**核心论点**：DDD 是工具箱，不是教条。

### 四个红色信号

看到这些就别硬上 DDD：

1. **业务简单到 CRUD 就够**（不需要建模复杂业务规则）
2. **团队没有"业务专家 ↔ 开发者"的对话习惯**（没有产品经理 or 业务方愿意花时间解释领域）
3. **项目时间紧、人少**（DDD 前期投入大，1 个月要上线的项目不适合）
4. **领域本身还在剧烈变化**（DDD 适合稳定领域，不适合"探索期"产品）

### 判断框架

- **中 0-1 条**：放心用 DDD，团队和项目都准备好了
- **中 2 条**：可以用 DDD 战术模式（entity/VO/aggregate）试试，战略模式暂缓
- **中 3 条以上**：先不上 DDD，把业务跑通、团队培养起来再说

---

## §7 延伸阅读：先读哪本（500 字）

明确给出阅读梯度：

| 顺序 | 书名 | 特点 | 阅读建议 |
| --- | --- | --- | --- |
| 1 | Vaughn Vernon《领域驱动设计精粹》（DDD Distilled） | 薄，概念完整 | 1-2 周读完，作为入门地图 |
| 2 | Vaughn Vernon《实现领域驱动设计》（IDDD） | 含 Java 示例，战术深入 | 重点看 entity/VO/aggregate/repo/domain event |
| 3 | Eric Evans《领域驱动设计：软件核心复杂性应对之道》 | 原版，500+ 页 | 战略 + 完整概念，但密度大 |

**中译本**：三本都有中文翻译版，人民邮电出版社 / 机械工业出版社等。

---

## §8 结尾（500 字）

**核心论点**：把 DDD 当工具箱，不当教条。

**收束句**（呼应开头）：
> DDD 不是写 class 的规矩。它是"让软件说出业务的话"的一门手艺。先理解战略（怎么切分），再上手战术（怎么建模），最后用业务复杂度反向验证你切得对不对。

**最后的建议**：
- 别一上来就重写整个项目
- 选 1 个新功能 or 1 个新模块试 DDD
- 跑 3 个月，反思哪些假设错了
- 然后决定要不要扩大范围

---

## 配套资产

### 4 张 Mermaid 图（待生成）

| # | 位置 | 内容 |
| --- | --- | --- |
| 1 | §3.2 | 电商系统限界上下文划分（5 框 + 依赖箭头） |
| 2 | §3.3 | 上下文地图（标注 Shared Kernel / Customer-Supplier / ACL 等关系） |
| 3 | §3.4 | 子域三层蛋糕图（核心/支撑/通用） |
| 4 | §4.3 | Order 聚合内部结构（聚合根 + 实体 + 值对象） |

### 3 段 TypeScript 代码（待写）

| # | 位置 | 内容 | 约行数 |
| --- | --- | --- | --- |
| 1 | §4.1 | User entity（branded type ID） | 30 |
| 2 | §4.2 | Money + Address 值对象 | 30 |
| 3 | §4.3 | Order 聚合（含 OrderItem） | 50 |

---

## 写稿 checklist

- [ ] §1 开头用第一人称叙事（"我曾经..."）
- [ ] §2 失败案例具体到一个 SaaS（避免泛泛而谈）
- [ ] §3 三张 Mermaid 图都生成并贴图
- [ ] §4 三段 TS 代码都本地跑过
- [ ] §5 Example Mapping 案例有清晰的视觉呈现（缩进/颜色标记）
- [ ] §6 四个红色信号用图标或加粗
- [ ] §7 表格化阅读梯度
- [ ] 全文每个 DDD 术语首次出现时给中英对照（如"通用语言（Ubiquitous Language）"）
- [ ] 全文 12000-14500 字
- [ ] 通读检查术语一致性
- [ ] 通读检查代码块语法（`ts` 标记）
- [ ] 通读检查 Mermaid 块语法（`mermaid` 标记）
