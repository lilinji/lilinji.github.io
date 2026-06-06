---
title: "给 Claude、Codex 和 Gemini 装上超能力的 50 个 MCP 服务器（免费指南）"
date: 2026-06-04T00:00:00+08:00
draft: false
tags:
  - AI相关
  - 翻译
author: Ringi Lee
showToc: true
tocOpen: false
source: "https://x.com/exploraX_/status/2062448236439155173"
translate-from: "https://x.com/exploraX_/status/2062448236439155173"
---

![Image](a335ebff1aa85e9e06b522d8f7b52281.jpg)

**MCP（模型上下文协议）最初只是 Anthropic 在 2024 年底推出的一个小众规范。**

十八个月后的今天，它已经成为所有主流 AI 代理的标准接口——Claude Code、Gemini CLI、Codex、Cursor、Windsurf，无一例外。

它的核心理念简单到无聊：与其让每个模型为每个工具写一套定制集成，不如让模型只说一次 MCP，所有支持 MCP 的工具就自动可用。

**Anthropic 把它比作 AI 的 USB-C 接口。** 这个比喻恰如其分。

> **嘿，我是 m0h，X 上的研究者和内容创作者，入行 5 年以上。我每天发布类似这样的内容，拆解 AI、代理和塑造新世界的工具，用真正能帮你上手的方式。关注 + 转发让更多人看到，收藏起来，你会想回来看的。**

如今 MCP 的生态已经极其庞大。公共注册表上有超过 20,000 个服务器，到 2026 年 3 月，SDK 的月下载量已经达到约 9700 万次。

其中大部分是垃圾——被遗弃的周末项目、半成品实验，甚至更糟。

最近的一项审计发现，大约三分之二的热门服务器存在安全问题。所以在看这个列表之前，有三条规则比整个列表都重要：

1. **别装 50 个。** 连接超过 5-7 个服务器，你的代理就会被工具膨胀拖垮——变慢变笨。挑 3-5 个真正匹配你工作场景的。这是菜单，不是购物车。
2. **把每个服务器当成陌生人 GitHub 上的 CLI 来对待。** 锁定版本。在观察代理如何使用之前，把 token 的权限范围设为只读。优先选择官方版本而非随机 fork。
3. **永远不要在代理循环中开启对生产环境的写操作。** 指向只读副本或快照。

关于安装方式的一个简短说明。三大代理各自有不同的配置路径，但底层的 JSON 结构基本相同：

- **Claude Code** → claude mcp add <name> ...（或 --transport http 用于托管服务器）
- **Codex** → codex mcp add <name> -- <command>，或编辑 ~/.codex/config.toml
- **Gemini CLI** → 编辑 ~/.gemini/settings.json，同样的 mcpServers 配置块

对于托管服务器（https URL），通常在三个代理中都能通过 http 传输和浏览器 OAuth 流程使用。

对于本地服务器（npx/uvx），你只需把相同的命令块放进每个代理的配置文件即可。我会给出每个的 Claude 命令，并在 Codex/Gemini 有不同时注明。

**开始吧。按你实际的工作场景分组。**

## 通用核心——先装这些

这五个在任何环境下都能用，在几乎任何机器上都值得占一个位置。

**1. GitHub**

仓库、Pull Request、Issue、代码搜索，覆盖你整个组织——不用离开终端。

搭配 Sentry 使用，你的代理可以读取一个生产错误，然后一步到位地提交修复 PR。

官方服务器在 2026 年取代了所有社区 fork；不要用其他任何版本。

- 安装：

```text
claude mcp add --transport http github https://api.githubcopilot.com/mcp/ -H "Authorization: Bearer YOUR_GITHUB_PAT"
```

（或添加后通过 /mcp 完成 OAuth 流程）

- 链接：[https://github.com/github/github-mcp-server](https://github.com/github/github-mcp-server)
- 注意：限制 token 权限范围。除非代理确实需要推送，否则设为只读。旧的 @modelcontextprotocol/server-github npm 包已不再维护——使用上面的托管服务器。

**2. Context7**

专门解决代理胡编包 API 的问题。它不是基于过时的训练数据生成代码，而是在查询时拉取最新的、版本锁定的文档。对于快速迭代的框架和云 SDK 来说必不可少。

- 安装：

```text
claude mcp add --transport http context7 https://mcp.context7.com/mcp
```

- Codex：

```text
codex mcp add context7 -- npx -y @upstash/context7-mcp
```

- 链接：[https://context7.com](https://context7.com/)
- 注意：免费使用，可选 API key 以获得更高频率限制。

**3. Playwright**

一个真正的浏览器，代理可以驱动它——打开页面、点击、填写表单、截图、用自然语言描述运行冒烟测试。由 Microsoft 维护。

- 安装：

```text
claude mcp add playwright npx @playwright/mcp@latest
```

- 链接：[https://github.com/microsoft/playwright-mcp](https://github.com/microsoft/playwright-mcp)
- 注意：适合探索性测试，不适合发布关键的回归测试——那种场景你需要确定性脚本。在 Windows 上，Claude Code 默认使用 git bash；需要切换到 cmd，否则命令会失败。

**4. Filesystem**

在代理的工作目录之外提供受范围限制的本地文件访问。stdio 模式，本地运行，速度快。

- 安装：（将允许的路径作为参数传入）

```text
claude mcp add filesystem npx @modelcontextprotocol/server-filesystem ~/projects
```

- 链接：[https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem](https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem)
- 注意：只暴露你想让代理访问的目录。这是一个宽泛的权限，请像对待宽泛权限那样谨慎。（这是 Anthropic 在主参考仓库中仍积极维护的少数服务器之一。）

**5. Brave Search**

在代理内部进行快速网络搜索，让它能基于事实回答问题，而不用你切换标签页。

- 安装：（需要 Brave API key 作为环境变量）

```text
claude mcp add brave-search npx @brave/brave-search-mcp-server
```

- 链接：[https://github.com/brave/brave-search-mcp-server](https://github.com/brave/brave-search-mcp-server)
- 注意：需要一个免费 key。放在用户级别的设置中，永远不要提交到代码仓库。注意：旧的 @modelcontextprotocol/server-brave-search 参考服务器已归档——Brave 现在维护自己的版本。

## 数据库与后端

**6. PostgreSQL**

直接对数据库执行 SQL——schema 感知的调试、在写迁移之前检查数据结构。

- 安装：

```text
claude mcp add postgres npx @modelcontextprotocol/server-postgres "postgresql://user:pass@localhost:5432/db"
```

- 链接：[https://github.com/modelcontextprotocol/servers-archived/tree/main/src/postgres](https://github.com/modelcontextprotocol/servers-archived/tree/main/src/postgres)
- 注意：提醒一下——Anthropic 的参考 PostgreSQL 服务器已归档。npm 包仍然可以安装和使用，但不再维护。在 2026 年做正经事，请使用你的服务商的官方服务器（下面的 Supabase/Neon）或 @bytebase/dbhub（Claude 自己的文档现在指向它）。默认只读。永远不要指向生产环境的写操作。

**7. Supabase**

通过聊天控制你的整个后端——数据库、认证、存储、Edge Functions。官方维护，积极更新。

- 安装：

```text
claude mcp add --transport http supabase https://mcp.supabase.com/mcp
```

- 链接：[https://github.com/supabase-community/supabase-mcp](https://github.com/supabase-community/supabase-mcp)
- 注意：以只读模式开始。它默认如此是有原因的——只有在你信任这个循环之后才开启写操作。

**8. Neon**

无服务器 PostgreSQL，有一个杀手级功能：基于分支的迁移。当代理执行迁移时，它会从生产数据瞬间创建一个写时复制分支，在那里测试，然后应用。官方维护。

- 安装：

```text
claude mcp add --transport http neon https://mcp.neon.tech/mcp
```

- 链接：[https://github.com/neondatabase/mcp-server-neon](https://github.com/neondatabase/mcp-server-neon)
- 注意：Neon 全力押注托管远程服务器——本地 npm 包和 stdio CLI 在 2026 年初已被移除。使用 URL。

**9. SQLite**

对 .db 文件执行本地 SQL。非常适合查看数据集或调试嵌入式存储。

- 安装：

```text
claude mcp add sqlite npx mcp-server-sqlite-npx /path/to/db.sqlite
```

- 链接：[https://github.com/johnnyoshika/mcp-server-sqlite-npx](https://github.com/johnnyoshika/mcp-server-sqlite-npx)
- 注意：Anthropic 的参考 SQLite 服务器也已归档。mcp-server-sqlite-npx 是目前大多数环境使用的社区维护替代方案。

**10. Redis**

检查键、管理缓存、监控内存——不用背 Redis CLI 命令。官方维护，来自 Redis 自己。

- 安装：

```text
clone redis/mcp-redis, run via uv with your redis url in env
```

- 链接：[https://github.com/redis/mcp-redis](https://github.com/redis/mcp-redis)
- 注意：在连接代理之前，用 Redis ACL 只读用户锁定它。

## 运维、基础设施与云

**11. Cloudflare**

Workers、DNS、R2、KV、Zero Trust——整个 API。主服务器通过两个工具（search/execute）覆盖 2,500+ 个端点，只用约 1k token 而不是泄露整个规范。

- 安装：在配置中添加

```text
{"url": "https://mcp.cloudflare.com/mcp"}
```

连接后会跳转到 Cloudflare 进行授权和选择权限

- 链接：[https://github.com/cloudflare/mcp](https://github.com/cloudflare/mcp)
- 注意：Cloudflare 还提供产品专用服务器（文档、可观测性、DNS 分析）。如果只需要某个功能，用专门的那个。

**12. Vercel**

部署、环境变量、日志检查。官方维护。

- 安装：

```text
claude mcp add --transport http vercel https://mcp.vercel.com
```

- 链接：[https://vercel.com/docs/mcp](https://vercel.com/docs/mcp)
- 注意：部署和环境变量的变更是真正的副作用。任何涉及发布的操作都要让人参与。

**13. AWS**

通过自然语言操作 EC2、S3、Lambda、RDS。

- 安装：AWS 按服务发布 MCP 服务器；从 awslabs 仓库安装你需要的
- 链接：[https://github.com/awslabs/mcp](https://github.com/awslabs/mcp)
- 注意：IAM 权限范围在这里至关重要。给代理一个严格限定权限的角色，而不是你的管理员密钥。

**14. Docker Hub**

镜像搜索、标签管理——如果你的工作离不开容器的话很有用。

- 安装：

```text
claude mcp add docker npx mcp-server-docker
```

- 链接：[https://hub.docker.com](https://hub.docker.com/)
- 注意：社区维护。在授予读取以外的权限之前先审查源代码。

**15. Sentry**

Issue、堆栈跟踪、事件详情直接传入代理。GitHub + Sentry 的组合是杀手级——读取一个生产错误，提交一个修复 PR。

- 安装：

```text
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp
```

- 链接：[https://docs.sentry.io/product/sentry-mcp/](https://docs.sentry.io/product/sentry-mcp/)
- 注意：堆栈跟踪和面包屑可能携带敏感数据。注意你给模型喂了什么。

**16. Kubernetes**

集群检查和 kubectl 风格的操作，用自然语言完成。

- 安装：

```text
claude mcp add kubernetes npx mcp-server-kubernetes
```

- 链接：[https://github.com/Flux159/mcp-server-kubernetes](https://github.com/Flux159/mcp-server-kubernetes)
- 注意：社区维护。先指向非生产环境的 context。一个拥有集群写权限的代理，就是一场等待发生的灾难。

## 企业/团队与生产力

**17. Slack**

消息、频道历史、发帖。

- 安装：原始的 Anthropic 参考服务器已归档，现在由 Zencoder 维护为 @zencoderai/slack-mcp-server（npx，需要 Slack bot/app tokens 作为环境变量）。查看仓库了解当前的 token 设置。
- 链接：[https://github.com/zencoderai/slack-mcp-server](https://github.com/zencoderai/slack-mcp-server)
- 注意：我无法确认是否有官方 Slack 托管的远程端点，所以使用维护中的社区服务器，而不是猜测一个 URL。向频道发帖是带受众的副作用——在代理发送任何人类可见的内容之前先确认。

**18. Linear**

Issue、Sprint 规划、搜索。官方远程服务器。

- 安装：添加远程服务器并完成 OAuth；Linear 的文档页面有当前端点和每个客户端的一键设置
- 链接：[https://linear.app/docs/mcp](https://linear.app/docs/mcp)
- 注意：权限继承你的 Linear 访问权限。代理能做你能做的一切。

**19. Notion**

页面和数据库。官方托管服务器（MakeNotion），取代了社区 fork。

- 安装：

```text
claude mcp add --transport http notion https://mcp.notion.com/sse
```

然后完成 OAuth

- 链接：[https://developers.notion.com/guides/mcp/mcp](https://developers.notion.com/guides/mcp/mcp)
- 注意：将集成范围限制到你需要访问的工作区，而不是全部。Notion 正在优先推广远程服务器，可能会停止支持本地版本。

**20. Jira / Confluence（Atlassian Rovo）**

Issue、Confluence 文档、Compass。官方 Atlassian Rovo 远程服务器覆盖所有这些。

- 安装：

```text
claude mcp add --transport http atlassian https://mcp.atlassian.com/v1/mcp/authv2
```

然后完成 OAuth

- 链接：[https://www.atlassian.com/platform/remote-mcp-server](https://www.atlassian.com/platform/remote-mcp-server)
- 注意：旧的 /v1/sse 端点在 2026 年 6 月 30 日后停止工作——使用上面的 /mcp 端点。OAuth 2.1，遵循你现有的访问控制。

**21. Google Drive**

跨 Drive 的文件搜索和读取。

- 安装：

```text
claude mcp add gdrive npx @modelcontextprotocol/server-gdrive
```

- 链接：[https://github.com/modelcontextprotocol/servers-archived/tree/main/src/gdrive](https://github.com/modelcontextprotocol/servers-archived/tree/main/src/gdrive)
- 注意：这个参考服务器也已归档——能用但不维护。OAuth 范围决定它能看到什么。尽量授予只读权限和特定文件夹的访问权。

**22. Gmail**

读取和发送邮件。

- 安装：社区服务器，通过 npx 安装，首次调用时进行 OAuth
- 链接：[https://github.com/GongRzhe/Gmail-MCP-Server](https://github.com/GongRzhe/Gmail-MCP-Server)
- 注意：发送是一个从你账户发出的副作用。永远不要让代理在无人监督的情况下发送邮件。社区维护——先审查。

**23. Google Calendar**

日程、排期、可用性检查。

- 安装：社区服务器，通过 npx 安装，首次调用时进行 OAuth
- 链接：[https://github.com/nspady/google-calendar-mcp](https://github.com/nspady/google-calendar-mcp)
- 注意：创建邀请会通知真实的人。写入之前先确认。

**24. Asana**

任务、项目、工作量。官方 v2 远程服务器（2026 年初 GA）。

- 安装：

```text
claude mcp add --transport http asana https://mcp.asana.com/v2/mcp
```

然后完成 OAuth

- 链接：[https://developers.asana.com/docs/using-asanas-mcp-server](https://developers.asana.com/docs/using-asanas-mcp-server)
- 注意：不要使用旧的 /sse beta 端点——它已被弃用并在 2026 年 5 月关闭。继承你的 Asana 权限。

**25. Airtable**

记录、Base、Schema。

- 安装：

```text
claude mcp add airtable npx airtable-mcp-server (api key in env)
```

- 链接：[https://github.com/domdomegg/airtable-mcp-server](https://github.com/domdomegg/airtable-mcp-server)
- 注意：社区维护，口碑不错。将 PAT 的权限范围限制到特定的 Base。

## 支付与金融科技

**26. Stripe**

支付、订阅、退款、客户查询。官方维护。

- 安装：

```text
claude mcp add --transport http stripe https://mcp.stripe.com then complete oauth — or run locally with npx -y @stripe/mcp --api-key=YOUR_STRIPE_SECRET_KEY
```

- 链接：[https://docs.stripe.com/mcp](https://docs.stripe.com/mcp)
- 注意：退款和订阅变更涉及真金白银。Stripe 自己的文档建议在工具上启用人工确认，并警告与其他服务器混合时的提示注入风险。用受限 API key 控制权限范围。先设为只读，直到证明可以信任。

**27. PayPal**

发票、交易、付款，通过官方 PayPal Agent Toolkit / MCP。

- 安装：PayPal 提供官方远程 MCP 加 PayPal Agent Toolkit；按照 PayPal 开发者文档获取当前端点和 OAuth 设置
- 链接：[https://www.paypal.ai](https://www.paypal.ai/)
- 注意：和 Stripe 一样。涉及资金流动的工具要保持监督——每次写入操作都要确认。

**28. Plaid**

银行数据聚合、余额、交易。

- 安装：官方 Plaid MCP，OAuth 流程
- 链接：[https://plaid.com/docs/](https://plaid.com/docs/)
- 注意：这是人们的银行数据。只读，并且认真考虑上下文窗口中的数据会去哪里。

**29. QuickBooks**

记账、开票、对账。

- 安装：社区/Intuit 服务器，OAuth
- 链接：[https://developer.intuit.com](https://developer.intuit.com/)
- 注意：会计写入有下游后果（税务、审计）。让人工签字确认。

## 区块链与 Web3

整个部分的警告：这些涉及链上的真实资产，交易不可逆转。

设计良好的服务器从不持有你的私钥，并且总是让你在单独的钱包 UI 中确认。这个设计本身就是核心——尊重它。

**30. Base MCP**

Coinbase 的官方链上网关，2026 年 5 月 26 日推出。交换代币、发送资金、跟踪投资组合、调用 DeFi 协议（Uniswap、Morpho、Moonwell、Aerodrome、Avantis、Bankr、Virtuals）——全部通过聊天完成。

OAuth 2.1，完全非托管：服务器从不持有你的私钥。当代理请求交易时，它在本地构建调用并存储为待处理请求，你的 Base 账户会检索它供你审查和签名。没有你在 Base 应用中的批准，任何操作都不会在链上执行。

- 安装：在支持的客户端（Claude、ChatGPT、Cursor）中安装 Base MCP 并用你的 Base 账户认证——Base 的官方文档/博客有当前设置；我不在这里引用确切的端点字符串，因为我无法逐字符验证，而在涉及资金的服务器上给出错误的 URL 不值得冒这个险。
- 链接：[https://github.com/base/base-mcp](https://github.com/base/base-mcp)
- 注意：旧的 base-mcp npm 包已弃用——不要 npx base-mcp。并且要理解你授权的内容：这可以在不可逆转的链上移动真实资金。Base 应用中的审查和签名步骤是你的安全网。永远不要绕过它。

**31. Solana Agent Kit**

Solana 上的链上操作——转账、交换、代币操作。

- 安装：社区服务器，通过 npx 安装，钱包密钥作为环境变量
- 链接：[https://github.com/sendaifun/solana-agent-kit](https://github.com/sendaifun/solana-agent-kit)
- 注意：很多社区 Solana 服务器要求在环境变量中放一个热私钥。这是真正的风险。优先选择在单独钱包中签名的方案，永远不要把持有真实资金的密钥放在配置文件中。

**32. Thirdweb**

跨 EVM 链部署和交互智能合约。

- 安装：Thirdweb 提供 MCP 服务器；查看 Thirdweb 文档获取当前包/命令和密钥存放位置
- 链接：[https://portal.thirdweb.com](https://portal.thirdweb.com/)
- 注意：合约部署不可逆转且需要 Gas。先在测试网的 chain id 上测试。

**33. The Graph**

通过子图查询链上数据，无需运行索引器。

- 安装：社区服务器，通过 npx 安装
- 链接：[https://thegraph.com/docs/](https://thegraph.com/docs/)
- 注意：天然只读，低风险。主要是数据工具。

**34. Dune**

链上分析——从代理运行和读取 Dune 查询。

- 安装：社区服务器，Dune API key 作为环境变量
- 链接：[https://dune.com/docs/api/](https://dune.com/docs/api/)
- 注意：API 额度是计量的。一个话多的代理能很快烧完免费额度。

**35. Etherscan**

区块浏览器访问——合约验证、交易查询、ABI 获取。

- 安装：社区服务器，通过 npx 安装，Etherscan API key 作为环境变量
- 链接：[https://docs.etherscan.io](https://docs.etherscan.io/)
- 注意：只读。可以放心常开。

## 交易与市场

和 Web3 一样的警告，但更强烈：执行服务器会下真实的订单。市场波动意味着滑点。使用限价单，在批准前仔细审查代理建议的每笔交易，先用模拟盘。

**36. Alpaca**

官方服务器（v2，基于 FastMCP 重建）。交易美股、ETF、期权和加密货币，管理投资组合，获取实时数据——全部用自然语言。61 个工具。

- 安装：

```text
alpacahq/alpaca-mcp-server
```

用 API keys 配置；支持模拟和实盘环境

- 链接：[https://github.com/alpacahq/alpaca-mcp-server](https://github.com/alpacahq/alpaca-mcp-server)
- 注意：从模拟环境开始。说真的。像保护密码一样保护密钥，审查每个建议的订单——文档本身建议使用限价单而非市价单来控制滑点。

**37. CCXT**

对 20+ 加密货币交易所（Binance、Coinbase、Kraken、Bybit）的统一读取访问，用于市场数据和分析。

- 安装：社区服务器（lazydino），通过 npx 安装
- 链接：[https://github.com/lazy-dinosaur/ccxt-mcp](https://github.com/lazy-dinosaur/ccxt-mcp)
- 注意：社区维护。如果你开启交易执行而不仅仅是数据，你就进入了真金白银的领域——用相应的态度对待。

**38. Polygon.io**

市场数据源——股票、期权、外汇、加密货币、聚合数据和交易。

- 安装：Polygon.io 发布官方 MCP 服务器；从其文档获取当前包和 API key 设置
- 链接：[https://polygon.io/docs](https://polygon.io/docs)
- 注意：仅数据，无执行。干净安全。

**39. CoinGecko**

加密货币价格、市值、历史数据。

- 安装：

```text
claude mcp add --transport http coingecko https://mcp.api.coingecko.com/sse
```

- 链接：[https://docs.coingecko.com](https://docs.coingecko.com/)
- 注意：免费版有频率限制。研究用途足够。

**40. TradingView**

图表和市场数据上下文。

- 安装：社区服务器，通过 npx 安装
- 链接：[https://www.tradingview.com](https://www.tradingview.com/)
- 注意：社区维护且基于爬虫——TradingView 改版时可能会失效。当作尽力而为。

## 创作者工具——媒体与设计

**41. Higgsfield**

官方服务器，2026 年 4 月推出——30+ 图像和视频模型（Sora、Veo、Kling、Seedance）通过一个端点。研究、提示词优化、生成广告/视频/品牌内容。对于付费创意工作，这是提示词和成品资产之间缺失的那一层。

- 安装：通过官方 Higgsfield 连接器/托管端点连接，使用你的账户额度
- 链接：[https://higgsfield.ai](https://higgsfield.ai/)、[https://higgsfield.ai/cli](https://higgsfield.ai/cli)
- 注意：社区有一些"无限"fork，通过浏览器 cookie 爬取你的登录会话。跳过这些——它们经常崩溃，而且你把会话交给了第三方。使用官方连接器。

**42. DaVinci Resolve**

通过脚本 API 控制 Resolve Studio——时间线编辑、媒体池组织、渲染设置、调色、Fusion、Fairlight。对剪辑工作流来说真正强大。

- 安装：

```text
clone samuelgursky/davinci-resolve-mcp
```

（npm 启动器自动配置 Claude/Cursor/Codex），或通过 uv 安装 apvlv/davinci-resolve-mcp

- 链接：[https://github.com/samuelgursky/davinci-resolve-mcp](https://github.com/samuelgursky/davinci-resolve-mcp)
- 注意：社区维护（两个主要 fork）。需要 Resolve Studio 打开，且偏好设置 → 通用 → 外部脚本设为"本地"才能连接。

**43. Figma**

官方 Dev Mode 服务器。读取组件、变量、布局；从 Frame 生成代码；通过较新的写入画布功能，代理还可以创建和更新原生 Figma 内容。

- 安装：在 Figma 中启用桌面服务器（Dev Mode → Enable MCP），然后

```text
claude mcp add --transport http figma-desktop http://127.0.0.1:3845/mcp —
```

或使用远程服务器，功能最全

- 链接：[https://help.figma.com/hc/en-us/articles/32132100833559-Guide-to-the-Figma-MCP-server](https://help.figma.com/hc/en-us/articles/32132100833559-Guide-to-the-Figma-MCP-server)
- 注意：远程和桌面的区别很重要——远程是大多数人想要的；桌面用于特定的企业场景，在本地 3845 端口运行。

**44. ElevenLabs**

官方语音合成和音频服务器——生成语音、克隆声音、转录。免费版每月 10k 额度。

- 安装：添加 ElevenLabs 作为 uvx elevenlabs-mcp 命令块，ELEVENLABS\_API\_KEY 作为环境变量（Claude Desktop：设置 → 开发者 → 编辑配置）
- 链接：[https://github.com/elevenlabs/elevenlabs-mcp](https://github.com/elevenlabs/elevenlabs-mcp)
- 注意：需要安装 uv。在 Windows 上需要在 Claude Desktop 中启用开发者模式。语音克隆有明显的同意问题——只克隆你有权克隆的声音。

**45. Blender**

驱动 Blender 的 3D 引擎——从提示词创建场景、物体、材质、灯光。

- 安装：社区服务器，需要安装 Blender + 一个插件桥接
- 链接：[https://github.com/ahujasid/blender-mcp](https://github.com/ahujasid/blender-mcp)
- 注意：社区维护，设置难度中等。需要 Blender 打开且伴侣插件正在运行。

**46. Canva**

从模板生成和编辑设计。

- 安装：

```text
claude mcp add --transport http canva https://mcp.canva.com/mcp
```

- 链接：[https://www.canva.dev/docs/apps/mcp-server/](https://www.canva.dev/docs/apps/mcp-server/)
- 注意：首次调用时进行 OAuth。继承你的 Canva 账户访问权限。

**47. Ableton Live**

控制 Ableton——创建音轨、MIDI、设备，操作 Live Set。

- 安装：社区服务器，需要 Ableton + 一个 Remote Script 桥接
- 链接：[https://github.com/ahujasid/ableton-mcp](https://github.com/ahujasid/ableton-mcp)
- 注意：社区维护，小众，设置繁琐。适合音乐制作实验，不适合生产关键任务。

**48. YouTube**

视频搜索和字幕提取——非常适合研究和内容再利用。

- 安装：

```text
claude mcp add youtube npx @anaisbetts/mcp-youtube
```

- 链接：[https://github.com/anaisbetts/mcp-youtube](https://github.com/anaisbetts/mcp-youtube)
- 注意：社区维护。字幕可用性取决于视频是否有字幕。

## 推理与记忆层

这些不连接外部服务——它们让代理本身工作得更好。值得了解。

**49. Sequential Thinking**

强制代理将复杂问题分解为有序的、明确的步骤。适用于架构决策、大型重构、任何有复杂依赖关系的事情。Anthropic 参考服务器。

- 安装：

```text
claude mcp add sequential-thinking npx @modelcontextprotocol/server-sequential-thinking
```

- 链接：[https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking](https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking)
- 注意：纯推理辅助，零外部访问。只消耗 token。（仍在主参考仓库中积极维护。）

**50. Memory**

跨对话的持久记忆——代理维护一个实体和关系的知识图谱，以便在会话之间记住上下文。官方 Anthropic 服务器，本地存储。

- 安装：

```text
claude mcp add memory npx @modelcontextprotocol/server-memory
```

- 链接：[https://github.com/modelcontextprotocol/servers/tree/main/src/memory](https://github.com/modelcontextprotocol/servers/tree/main/src/memory)
- 注意：数据存储在本地。它的私密程度取决于它所在的机器。

## 如何真正选择

如果你做软件开发：GitHub、Context7、Playwright、你的数据库（PostgreSQL/Supabase/Neon）、Sentry。五个服务器，90% 的价值。

如果你做内容创作：Higgsfield、DaVinci Resolve、ElevenLabs、YouTube、Figma。这就是一条完整的创作者管线。

如果你做交易或链上工作：从只读开始——CoinGecko、Polygon、The Graph、Dune。只有在你完全理解确认流程之后再添加 Base MCP 或 Alpaca，并且先用模拟盘。

如果你用文档和票据管理公司：Slack、Linear/Jira、Notion、Google Drive。代理不再只是一个聊天窗口，而开始成为一个队友。

陷阱是因为听起来有用就安装所有东西。不要这样做。每个连接的服务器都会消耗上下文，拖慢你真正在乎的工作的性能。

三到五个精准选择永远胜过二十个平庸选择。每季度重新审视一次配置——这个生态系统变化很快，你在 2026 年 3 月之前设置的服务器可能已经被更快、认证更好的东西取代了。

选五个。接入。发布。

**~m0h**

<blockquote>
  原文地址：<a href="https://x.com/exploraX_/status/2062448236439155173">https://x.com/exploraX_/status/2062448236439155173</a>
</blockquote>
