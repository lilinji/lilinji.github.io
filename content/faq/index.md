---
title: "FAQ"
date: 2024-12-03T00:00:00+08:00
draft: false
description: "Frequently Asked Questions about Ringi's Log"
---

## 关于本博客

### 这个博客主要写什么内容?

本博客记录了作者技术栈的**演进与重构**。

早期（2013-2017）主要关注**云计算基础设施**，涵盖：
- **容器技术**: Docker、K8s、容器编排
- **OpenStack**: 虚拟化、Cinder、Nova 等核心组件
- **分布式存储**: Ceph、RBD、对象存储
- **Linux 运维**: 系统性能调优、网络虚拟化

近期（2024起）重心转向 **AGI 与 具身智能**，深度探索：
- **大语言模型 (LLM)**: Transformer 架构、SFT、RLHF 对齐
- **强化学习 (RL)**: 从基础的 Policy Gradient 到 PPO、DQN，再到多智能体协作
- **AI 系统**: GPU 集群算力优化、高性能计算 (HPC)
- **Agentic Workflow**: 智能体工作流设计与自动化

### 为什么会有这样的转变？

**Infrastructure is the bedrock of AI.** 

早期的云计算经验为理解 AI 算力基础设施打下了坚实基础。从管理成千上万台虚拟机，到调度数千卡 GPU 集群，底层逻辑一脉相承。现在的关注点是从"如何构建稳定的地基" 转向 "如何在算力之上构建智能"。

### 文章的技术栈是什么?

**New Stack (AI & Modern):**
- **Frameworks**: PyTorch, HuggingFace, DeepSpeed
- **Models**: Llama, Qwen, DeepSeek
- **Tools**: Cursor, LangChain, Flowise
- **Languages**: Python (Core), Rust/C++ (Performance)

**Legacy Stack (Cloud & Ops):**
- **Cloud**: OpenStack, Kubernetes
- **Storage**: Ceph
- **Languages**: Bash, Go
- **OS**: Linux (Ubuntu, CentOS)

