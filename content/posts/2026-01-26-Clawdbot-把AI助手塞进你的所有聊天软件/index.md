---
title: Clawdbot：把 AI 助手塞进你的所有聊天软件
date: 2026-01-26T10:00:00+08:00
draft: false
tags:
  - AI
  - Agent
  - Tutorial
  - IT
  - Tool
author: Ringi Lee
showToc: true
tocOpen: false
---

> 想象一下：你在 WhatsApp 上问 Claude 帮你写邮件，在 Telegram 上让它帮你查代码，在 Slack 里让它帮你做会议纪要，在 iMessage 上让它帮你安排日程——而这一切，都跑在你自己的电脑上，数据完全在本地。这就是 Clawdbot。

![Clawdbot 多平台接入概念](images/Gemini_Generated_Image_55gd7l55gd7l55gd.png)

## 一、这玩意儿到底是什么？

先说结论：**Clawdbot 是一个开源的、本地运行的 AI 助手框架，能把 Claude/GPT 这样的大模型接入到你日常使用的所有聊天软件里。**

GitHub 上 21.1k star，2.6k fork，MIT 开源协议。项目 slogan 很有意思："Your own personal AI assistant. Any OS. Any Platform. The lobster way. 🦞"（龙虾之道？大概是因为 logo 是只龙虾）

为什么这东西值得关注？三个字：**私有化**。

你用 ChatGPT 官方 app，数据全在 OpenAI 服务器上。你用 Claude web 版，数据全在 Anthropic 那边。但 Clawdbot 不一样——Gateway（控制中心）跑在你自己机器上，对话数据、文件操作、浏览器控制，全都在本地。你愿意的话，可以完全断网使用本地模型。

## 二、它能干什么？

![Clawdbot 核心功能矩阵](images/Gemini_Generated_Image_bb6q0sbb6q0sbb6q.png)

### 2.1 多平台接入

这是 Clawdbot 的核心卖点。支持的平台列表相当夸张：

| 平台 | 支持状态 |
|------|---------|
| WhatsApp | ✅ |
| Telegram | ✅ |
| Slack | ✅ |
| Discord | ✅ |
| Google Chat | ✅ |
| Signal | ✅ |
| iMessage | ✅ |
| Microsoft Teams | ✅ |
| Matrix | ✅ |
| Zalo | ✅ |
| WebChat | ✅ |
| BlueBubbles | ✅ |

13 个主流平台全覆盖。意味着什么？你不需要让别人下载新 app，不需要教他们怎么用 ChatGPT，直接在他们已经用的软件里就能访问 AI 助手。

你女朋友用 WhatsApp？接进去。你公司用 Slack？接进去。你爸妈用微信（通过 Matrix 桥接）？也能接进去。

### 2.2 语音交互

macOS/iOS/Android 都支持语音功能：

- **Voice Wake**：语音唤醒，类似"Hey Siri"
- **Talk Mode**：语音对话模式，不用打字

实际体验就是：你对着手机说"帮我查一下明天的天气"，它直接语音回复你。

### 2.3 实时 Canvas

这个功能有点意思。Clawdbot 有个可视化工作空间叫 Canvas，支持 A2UI（Agent to UI）。

什么意思？AI 可以主动在这个画布上画东西给你看。比如你让它帮你做个流程图，它不是输出一堆文字描述，而是直接在 Canvas 上画出来。

### 2.4 浏览器控制

内置 Chrome/Chromium 控制能力。AI 可以：

- 打开网页
- 点击按钮
- 填写表单
- 截图
- 提取内容

这意味着你可以让它帮你自动化一些网页操作。比如"帮我登录 XXX 网站，把这份报告下载下来"。

### 2.5 设备节点系统

这块比较硬核。Clawdbot 支持把手机、电脑变成"节点"，提供这些能力：

- **摄像头**：拍照、录视频
- **屏幕录制**：录屏
- **位置获取**：GPS 定位
- **通知推送**：系统通知
- **定时任务**：Cron jobs

场景举例：你在公司，让手机上的 Clawdbot 帮你拍一张家里的照片发过来，看看猫有没有在沙发上睡觉。

## 三、架构长什么样？

![Gateway 架构图](images/Gemini_Generated_Image_asxkuiasxkuiasxk.png)

这块稍微技术一点，但理解了对后面的安装配置有帮助。

```
WhatsApp / Telegram / Slack / Discord / etc.
              │
              ▼
┌─────────────────────────────────────┐
│     Gateway (control plane)         │
│     ws://127.0.0.1:18789           │
└──────────────────┬──────────────────┘
                   │
     ┌─────────────┼─────────────┐
     │             │             │
     ▼             ▼             ▼
  Pi agent      WebChat       macOS app
   (RPC)          UI         iOS/Android
```

核心是那个 **Gateway**。它是一个 WebSocket 服务，跑在 `127.0.0.1:18789`，所有消息都从这里进出。

你的 WhatsApp 消息过来 → Gateway 收到 → 转发给 AI Agent → Agent 处理 → 结果通过 Gateway 发回 WhatsApp。

为什么这样设计？**解耦**。

Gateway 只负责消息收发，不管你用什么 AI 模型。你今天用 Claude，明天换 GPT，后天用本地的 Llama，Gateway 那边完全不用改。

## 四、怎么安装？

![安装流程三步走](images/Gemini_Generated_Image_ad0telad0telad0t.png)

### 4.1 环境要求

- **Node.js ≥ 22**（注意版本，低了不行）
- 操作系统：macOS / Linux / Windows（WSL2）

### 4.2 一键安装

最简单的方式：

```bash
# npm 安装
npm install -g clawdbot@latest

# 或者用 pnpm（推荐）
pnpm add -g clawdbot@latest

# 运行安装向导
clawdbot onboard --install-daemon
```

`onboard` 命令会启动一个交互式向导，帮你配置：

1. Gateway 工作空间
2. 要接入的聊天渠道
3. AI 模型（Claude/GPT）
4. 安装守护进程（开机自启）

### 4.3 从源码安装（开发者）

如果你想改代码或者贡献开源：

```bash
git clone https://github.com/clawdbot/clawdbot.git
cd clawdbot

pnpm install
pnpm ui:build
pnpm build

pnpm clawdbot onboard --install-daemon

# 开发模式（热重载）
pnpm gateway:watch
```

### 4.4 配置文件

配置文件在 `~/.clawdbot/clawdbot.json`，最小配置：

```json
{
  "agent": {
    "model": "anthropic/claude-opus-4-5"
  }
}
```

各渠道的 token 配置：

```bash
# Telegram
export TELEGRAM_BOT_TOKEN="your-bot-token"

# Discord
export DISCORD_BOT_TOKEN="your-bot-token"

# 其他渠道类似
```

## 五、日常使用

### 5.1 启动服务

```bash
# 启动 Gateway
clawdbot gateway --port 18789 --verbose

# 发送消息
clawdbot message send --to +1234567890 --message "Hello from Clawdbot"

# 与 AI 对话
clawdbot agent --message "帮我写一封请假邮件" --thinking high
```

### 5.2 聊天指令

在任何接入的聊天软件里，你可以用这些命令：

| 命令 | 作用 |
|------|------|
| `/status` | 查看当前会话状态 |
| `/new` 或 `/reset` | 重置会话（清空上下文）|
| `/think <level>` | 设置思考深度：off/minimal/low/medium/high/xhigh |
| `/verbose on/off` | 切换详细模式 |
| `/activation mention/always` | 群组激活方式（@才响应 / 总是响应）|

### 5.3 思考深度

`/think` 这个参数值得说一下。

- **off**：不思考，直接回答，最快
- **minimal/low**：简单思考，适合日常问答
- **medium**：中等思考，适合写作、分析
- **high/xhigh**：深度思考，适合编程、复杂推理

思考深度越高，响应越慢，但质量越好。日常用 `low`，需要写代码时切到 `high`。

## 六、安全机制

![安全机制四层防护](images/Gemini_Generated_Image_jbcv36jbcv36jbcv.png)

开源 + 本地运行 ≠ 没有安全风险。Clawdbot 在这块做得比较细。

### 6.1 配对模式

默认情况下，陌生人给你发消息，AI 不会直接响应。

流程是这样的：
1. 陌生人发消息过来
2. Clawdbot 返回一个配对码
3. 你在本地执行 `clawdbot pairing approve <channel> <code>`
4. 配对成功，之后这个人就能正常对话了

想开放公开访问？需要显式配置：

```json
{
  "dmPolicy": "open",
  "allowlist": ["*"]
}
```

### 6.2 沙箱模式

非主会话可以跑在 Docker 容器里，隔离执行环境。

什么意思？比如你把 Clawdbot 开放给朋友用，朋友让 AI 执行一些代码。这些代码在 Docker 容器里跑，不会影响你的主机系统。

### 6.3 工具权限

可以配置工具白名单/黑名单：

```json
{
  "tools": {
    "whitelist": ["read", "write", "search"],
    "blacklist": ["execute_command", "browser_control"]
  }
}
```

这样即使 AI"想"执行危险操作，也没有对应的工具可用。

### 6.4 安全检查

```bash
clawdbot doctor
```

这个命令会检查常见的安全配置问题，比如是否意外开放了公开访问。

## 七、高级玩法

### 7.1 远程 Gateway

Gateway 不一定要跑在本地。你可以：

1. 在云服务器（Linux VPS）上跑 Gateway
2. 本地设备通过 Tailscale 或 SSH 隧道连接
3. 设备节点（摄像头、位置等）仍然在本地执行

好处？
- 服务器 24 小时在线，不用一直开着电脑
- 多设备共享同一个 AI 助手
- 手机没电也不影响消息接收

### 7.2 Tailscale 集成

Clawdbot 原生支持 Tailscale：

- **Serve 模式**：只在 tailnet 内部可访问
- **Funnel 模式**：对外公开（有域名）

```bash
clawdbot gateway --tailscale-serve
# 或
clawdbot gateway --tailscale-funnel
```

### 7.3 多 Agent 路由

可以把不同的聊天渠道路由到不同的 Agent：

- WhatsApp → 日常助手（Claude Sonnet）
- Slack → 工作助手（Claude Opus）
- Telegram → 编程助手（GPT-4）

每个 Agent 有独立的上下文、独立的工具权限。

### 7.4 Skills 扩展

Clawdbot 有个 Skills 注册中心叫 ClawdHub（clawdhub.com），可以下载社区贡献的技能包：

- 自动化工作流
- 特定领域助手
- 集成第三方服务

## 八、版本更新

```bash
# 查看当前版本
clawdbot --version

# 更新到最新稳定版
clawdbot update --channel stable

# 切换到测试版
clawdbot update --channel beta

# 切换到开发版
clawdbot update --channel dev
```

三个渠道：
- **stable**：稳定版，适合日常使用
- **beta**：预发布版，新功能抢先体验
- **dev**：开发版，可能有 bug

## 九、和同类产品比怎么样？

![Clawdbot vs 传统方案对比](images/Gemini_Generated_Image_zhdzm8zhdzm8zhdz.png)

市面上类似的东西有几个：

| 产品 | 特点 | 缺点 |
|------|------|------|
| ChatGPT 官方 app | 体验好 | 数据在云端，平台受限 |
| Claude 官方 | 能力强 | 只有 web 和 API |
| Open WebUI | 开源本地 | 只有 web 界面 |
| **Clawdbot** | 开源本地 + 多平台 | 配置稍复杂 |

Clawdbot 的核心差异化：**接入现有聊天平台**。

你不需要让别人学习新工具，直接在他们已经用的 app 里就能访问 AI。这降低了使用门槛，也更符合"AI 应该无处不在"的理念。

## 十、总结

Clawdbot 解决的问题很明确：**怎么把 AI 助手带到你已经在用的聊天软件里，同时保持数据私有化**。

适合这些人：
- 隐私敏感，不想把对话数据交给大公司
- 需要在多个聊天平台使用 AI
- 想做 AI 自动化但不想依赖第三方服务
- 喜欢折腾、愿意配置的开发者/极客

不适合这些人：
- 只想开箱即用，不愿意配置
- 只用一个聊天平台
- 对隐私不敏感，用官方 app 就够了

项目地址：https://github.com/clawdbot/clawdbot

官网：https://clawdbot.com

文档：https://docs.clawd.bot

---

*最后说句题外话：21k star 的开源项目，MIT 协议，社区活跃。如果你对 AI Agent 这个方向感兴趣，不管是用还是学，都值得看看它的代码。架构设计、多平台适配、安全机制，都是很好的学习材料。*
