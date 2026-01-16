# 使用 Antigravity 内置工具生成插图

**更新时间**: 2026-01-16 13:17  
**推荐级别**: ⭐⭐⭐⭐⭐ 最推荐！

---

## 🎉 好消息！

Antigravity 自带强大的图像生成功能（Google Gemini Imagen），**无需任何额外配置**即可使用！

---

## ✨ 主要优势

| 特性         | Antigravity 内置 | qwen-image        | DALL-E 3            |
| ------------ | ---------------- | ----------------- | ------------------- |
| **配置难度** | ⭐ 零配置        | ⭐⭐ 需要 API Key | ⭐⭐⭐ 需要 API Key |
| **使用成本** | ✅ 免费          | ¥0.08/张          | $0.04-0.08/张       |
| **图片质量** | ⭐⭐⭐⭐⭐ 优秀  | ⭐⭐⭐⭐ 很好     | ⭐⭐⭐⭐⭐ 优秀     |
| **生成速度** | 10-15 秒         | 10-20 秒          | 20-30 秒            |
| **中文支持** | ✅ 完美          | ✅ 完美           | ⭐⭐⭐ 一般         |
| **集成度**   | ✅ 无缝集成      | ❌ 需要外部调用   | ❌ 需要外部调用     |

**推荐指数**: 🥇 **第一选择！**

---

## 🚀 快速开始

### 基本用法

在 Antigravity 对话中直接请求：

```
"使用这个提示词生成图片: [粘贴提示词内容]"

或者

"读取 imgs/prompts/illustration-concept.md 文件并生成对应的图片"
```

### 实战示例

我们刚才生成的 5 张插图就是用这个方法！

**命令示例**:

```
请为文章生成插图，使用以下提示词：

[复制 imgs/prompts/illustration-skills-ecosystem.md 的内容]
```

---

## 📋 完整工作流程

### Step 1: 技能生成提示词

运行 baoyu-article-illustrator 技能：

```bash
/baoyu-article-illustrator article.md --style tech
```

生成文件结构：

```
article/
└── imgs/
    ├── outline.md
    └── prompts/
        ├── illustration-concept-1.md
        ├── illustration-concept-2.md
        └── illustration-concept-3.md
```

### Step 2: 读取提示词文件

在 Antigravity 中：

```
请读取以下文件并显示内容:
d:\lilinji.github.io\content\posts\my-article\imgs\prompts\illustration-concept-1.md
```

### Step 3: 生成图片

继续在 Antigravity 中：

```
请使用刚才读取的提示词生成图片，图片名称为 illustration_concept_1
```

### Step 4: 复制图片

生成的图片会保存在：

```
C:\Users\<用户名>\.gemini\antigravity\brain\<conversation-id>\illustration_concept_1_<timestamp>.png
```

复制到文章目录：

```powershell
Copy-Item -Path "C:\Users\...\brain\...\illustration_concept_1_*.png" `
          -Destination "d:\lilinji.github.io\content\posts\my-article\imgs\illustration-concept-1.png"
```

### Step 5: 更新文章

在文章中插入：

```markdown
![Concept Illustration](imgs/illustration-concept-1.png)
```

---

## 🔄 批量生成流程

### 方法 1: 逐个生成（推荐新手）

```
1. 读取第一个提示词文件
2. 生成图片 1
3. 复制图片 1 到目标位置
4. 重复步骤 1-3 用于剩余图片
```

### 方法 2: 一次性生成（推荐熟练用户）

在 Antigravity 中：

```
我有 5 个插图需要生成，提示词文件在:
- imgs/prompts/illustration-skills-ecosystem.md
- imgs/prompts/illustration-agent-workflow.md
- imgs/prompts/illustration-mcp-architecture.md
- imgs/prompts/illustration-skill-marketplace.md
- imgs/prompts/illustration-use-cases.md

请逐个读取这些文件并生成对应的图片。
生成的图片名称分别为:
- illustration_skills_ecosystem
- illustration_agent_workflow
- illustration_mcp_architecture
- illustration_skill_marketplace
- illustration_use_cases
```

---

## 💡 提示词优化技巧（针对 Gemini Imagen）

### 1. 使用详细描述

❌ **太简略**:

```
一个技术图
```

✅ **详细具体**:

```
Modern tech illustration with Claude AI logo at center, surrounded by
glowing hexagonal nodes in deep blue (#1A365D) and electric cyan (#00D4FF).
Dark gray-black gradient background. Circuit board texture. Cyberpunk
aesthetic with soft glowing effects.
```

### 2. 明确指定颜色

```
配色方案:
- 主色: Deep blue (#1A365D)
- 背景: Dark gray-black (#1A202C)
- 点缀: Electric cyan (#00D4FF), Neon green (#00FF88)
```

### 3. 描述布局和构图

```
Visual composition:
- Main visual: Neural network at center
- Layout: Radial layout expanding from center
- Connections: Glowing data flow lines
```

### 4. 包含风格关键词

```
Style keywords: tech, futuristic, professional, modern, cyberpunk
Atmosphere: innovative, cutting-edge, advanced
```

### 5. 中英文混合效果更好

```
插图主题: Claude Skills 生态系统
Style: tech

视觉构成:
- Main visual: Claude logo with glowing hexagonal skill nodes
- 布局: Radial layout / 辐射状布局
- Decorative elements: Circuit patterns, geometric grid

配色: Deep blue, electric cyan, dark background
```

---

## 📊 实际案例回顾

我们刚才为《Claude Skills 精选合集》生成的 5 张插图：

### 案例 1: Skills 生态系统

**提示词长度**: 约 300 字  
**生成时间**: 约 12 秒  
**图片质量**: ⭐⭐⭐⭐⭐  
**效果**: 完美展示了生态系统的网络拓扑

### 案例 2: Agent 工作流程

**提示词长度**: 约 250 字  
**生成时间**: 约 10 秒  
**图片质量**: ⭐⭐⭐⭐⭐  
**效果**: 清晰展示 4 步流程

### 案例 3: MCP 架构

**提示词长度**: 约 280 字  
**生成时间**: 约 11 秒  
**图片质量**: ⭐⭐⭐⭐⭐  
**效果**: 准确呈现 3 层架构

### 案例 4: 技能市场仪表板

**提示词长度**: 约 300 字  
**生成时间**: 约 13 秒  
**图片质量**: ⭐⭐⭐⭐⭐  
**效果**: 数据可视化效果出色

### 案例 5: 应用场景

**提示词长度**: 约 320 字  
**生成时间**: 约 14 秒  
**图片质量**: ⭐⭐⭐⭐⭐  
**效果**: 8 个场景图标清晰美观

**总体满意度**: 100% ✅

---

## 🎯 最佳实践

### 1. 提示词准备

- ✅ 使用 baoyu-article-illustrator 生成的提示词文件
- ✅ 提示词包含详细的视觉描述
- ✅ 明确指定配色（带色值）
- ✅ 描述布局和氛围

### 2. 生成过程

- ✅ 逐个生成，确保质量
- ✅ 检查生成结果
- ✅ 必要时重新生成
- ✅ 保存原始提示词

### 3. 图片管理

- ✅ 使用有意义的文件名
- ✅ 按文章组织目录
- ✅ 保留生成记录
- ✅ 备份重要图片

---

## 🔧 自动化脚本

### PowerShell 批量复制图片

```powershell
# copy_images.ps1

$brainPath = "C:\Users\lilinji\.gemini\antigravity\brain\22f18893-ce5a-4b06-acb1-9faa7af9ad69"
$articlePath = "d:\lilinji.github.io\content\posts\claude-skills-collection"
$imgsPath = "$articlePath\imgs"

# 定义图片映射
$images = @{
    "illustration_skills_ecosystem" = "illustration-skills-ecosystem.png"
    "illustration_agent_workflow" = "illustration-agent-workflow.png"
    "illustration_mcp_architecture" = "illustration-mcp-architecture.png"
    "illustration_skill_marketplace" = "illustration-skill-marketplace.png"
    "illustration_use_cases" = "illustration-use-cases.png"
}

# 复制所有图片
foreach ($key in $images.Keys) {
    $source = Get-ChildItem "$brainPath\$key*.png" | Select-Object -First 1
    $dest = "$imgsPath\$($images[$key])"

    if ($source) {
        Copy-Item -Path $source.FullName -Destination $dest -Force
        Write-Host "✓ 已复制: $($images[$key])"
    } else {
        Write-Host "✗ 未找到: $key"
    }
}

Write-Host "`n完成！所有图片已复制到: $imgsPath"
```

使用:

```powershell
.\copy_images.ps1
```

---

## ❓ 常见问题

### Q1: 如何查看生成的图片？

**A**: 图片会自动显示在 Antigravity 的对话中，您可以直接预览。

### Q2: 图片保存在哪里？

**A**: 保存在 `C:\Users\<用户名>\.gemini\antigravity\brain\<conversation-id>\` 目录下。

### Q3: 可以修改图片吗？

**A**: 可以！

- 修改提示词后重新生成
- 使用图片编辑工具调整
- 在 Antigravity 中请求修改

### Q4: 生成失败怎么办？

**A**:

1. 检查提示词是否清晰明确
2. 尝试简化或重组提示词
3. 重新生成一次

### Q5: 能同时生成多张图片吗？

**A**: 建议**逐个生成**，这样可以：

- 确保每张图片质量
- 及时调整提示词
- 更好地管理文件

---

## 🌟 为什么选择 Antigravity 内置工具？

### 优势总结

1. **零配置** - 开箱即用
2. **免费** - 无需额外费用
3. **高质量** - Gemini Imagen 效果优秀
4. **无缝集成** - 直接在对话中完成
5. **中英文友好** - 完美支持
6. **快速** - 10-15 秒生成
7. **稳定** - Google 基础设施支持

### 与其他方案对比

| 方案 | Antigravity | qwen-image | DALL-E 3  |
| ---- | ----------- | ---------- | --------- |
| 配置 | ✅ 无需     | ⚠️ 需要    | ⚠️ 需要   |
| Cost | ✅ 免费     | ⚠️ 付费    | ⚠️ 付费   |
| 质量 | ✅ 优秀     | ✅ 很好    | ✅ 优秀   |
| 速度 | ✅ 快       | ✅ 快      | ⚠️ 中等   |
| 易用 | ✅ 最简单   | ⚠️ 需脚本  | ⚠️ 需脚本 |

**结论**: Antigravity 内置工具是 **最佳选择**！

---

## 📝 总结

使用 Antigravity 内置的图像生成功能：

✅ **最简单** - 无需任何配置  
✅ **最经济** - 完全免费  
✅ **最快捷** - 集成在对话中  
✅ **最可靠** - Google 技术支持

**开始使用**:

1. 运行 baoyu-article-illustrator 生成提示词
2. 在 Antigravity 中读取提示词
3. 请求生成图片
4. 复制到文章目录
5. 完成！

---

**更新时间**: 2026-01-16 13:17  
**文档版本**: 1.0  
**推荐级别**: ⭐⭐⭐⭐⭐
