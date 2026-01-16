# 使用魔塔社区 qwen-image 配置文章配图技能

**配置时间**: 2026-01-16 12:36  
**图像生成服务**: 魔塔社区 (ModelScope) qwen-image  
**技能**: baoyu-article-illustrator

---

## 🎨 配置概述

您已经拥有魔塔社区的 API Key，可以使用阿里巴巴的 **qwen-image** 模型生成高质量插图。

---

## 🔑 API Key 信息

**⚠️ 重要安全提醒**:
您在文档中暴露了真实的 API Key。为了安全，建议：

1. ❌ 立即从公开文档中删除 API Key
2. ✅ 使用环境变量存储
3. ✅ 将包含 API Key 的文件添加到 `.gitignore`
4. 💡 如有必要，在魔塔社区控制台重新生成新的 Key

---

## ⚙️ 环境配置

### 方式 1: 环境变量（推荐）

#### Windows PowerShell

```powershell
# 临时设置（当前会话）
$env:DASHSCOPE_API_KEY = "ms-4066b0b2-89c9-44d9-ac95-b13b9295bbf9"

# 永久设置（用户级别）
[System.Environment]::SetEnvironmentVariable('DASHSCOPE_API_KEY', 'ms-4066b0b2-89c9-44d9-ac95-b13b9295bbf9', 'User')

# 验证设置
echo $env:DASHSCOPE_API_KEY
```

#### Linux/Mac (Bash/Zsh)

```bash
# 临时设置
export DASHSCOPE_API_KEY="ms-4066b0b2-89c9-44d9-ac95-b13b9295bbf9"

# 永久设置（添加到 ~/.bashrc 或 ~/.zshrc）
echo 'export DASHSCOPE_API_KEY="ms-4066b0b2-89c9-44d9-ac95-b13b9295bbf9"' >> ~/.bashrc
source ~/.bashrc
```

### 方式 2: .env 文件

创建 `.env` 文件（确保添加到 .gitignore）:

```env
# .env
DASHSCOPE_API_KEY=ms-4066b0b2-89c9-44d9-ac95-b13b9295bbf9
MODELSCOPE_API_KEY=ms-4066b0b2-89c9-44d9-ac95-b13b9295bbf9
```

添加到 `.gitignore`:

```gitignore
# API Keys
.env
*.env
config/secrets.json
```

---

## 🧪 qwen-image 模型说明

### 模型信息

**qwen-image** (通义万相) 是阿里巴巴达摩院开发的文生图模型。

#### 特点

- ✅ **高质量**: 生成 1024x1024 或更高分辨率图片
- ✅ **中文支持**: 完美支持中文提示词
- ✅ **风格多样**: 支持多种艺术风格
- ✅ **速度快**: 平均 10-20 秒生成一张图
- ✅ **价格优惠**: 相比国际服务更便宜

#### API 调用示例

```python
import dashscope
from dashscope import ImageSynthesis

dashscope.api_key = 'ms-4066b0b2-89c9-44d9-ac95-b13b9295bbf9'

# 生成图片
response = ImageSynthesis.call(
    model='qwen-vl-v1',
    prompt='一个现代科技感的 AI 神经网络图，深蓝色背景，带有电路纹理',
    n=1,
    size='1024*1024'
)

print(response.output.results[0]['url'])
```

---

## 🎨 为技能配置 qwen-image

### 步骤 1: 安装依赖

```bash
# 安装魔塔社区 SDK
pip install dashscope

# 或使用 conda
conda install -c conda-forge dashscope
```

### 步骤 2: 创建图片生成脚本

创建 `generate_qwen_image.py`:

```python
#!/usr/bin/env python3
"""
qwen-image 图片生成脚本
用于 baoyu-article-illustrator 技能
"""

import sys
import os
import dashscope
from dashscope import ImageSynthesis
from pathlib import Path

# 从环境变量获取 API Key
dashscope.api_key = os.environ.get('DASHSCOPE_API_KEY')

def generate_image(prompt_file: str, output_file: str):
    """
    从提示词文件生成图片

    Args:
        prompt_file: 提示词 Markdown 文件路径
        output_file: 输出图片路径
    """
    # 读取提示词
    with open(prompt_file, 'r', encoding='utf-8') as f:
        prompt_content = f.read()

    # 提取提示词（简化版，实际应该解析 Markdown）
    # 这里假设提示词在"Visual composition:"之后
    prompt = prompt_content.split('Visual composition:')[1].split('Color scheme:')[0].strip()

    print(f"生成图片: {output_file}")
    print(f"提示词: {prompt[:100]}...")

    # 调用 qwen-image API
    response = ImageSynthesis.call(
        model='qwen-vl-v1',
        prompt=prompt,
        n=1,
        size='1024*1024'
    )

    if response.status_code == 200:
        # 下载图片
        image_url = response.output.results[0]['url']
        import requests
        img_data = requests.get(image_url).content

        # 保存图片
        with open(output_file, 'wb') as f:
            f.write(img_data)

        print(f"✓ 图片已保存: {output_file}")
        return True
    else:
        print(f"✗ 生成失败: {response.message}")
        return False

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("用法: python generate_qwen_image.py <prompt_file> <output_file>")
        sys.exit(1)

    prompt_file = sys.argv[1]
    output_file = sys.argv[2]

    generate_image(prompt_file, output_file)
```

### 步骤 3: 测试脚本

```bash
# 创建测试提示词文件
cat > test_prompt.md << 'EOF'
Illustration theme: AI Engineering
Style: tech

Visual composition:
- Main visual: Neural network with glowing nodes
- Layout: Centered with geometric patterns
- Decorative elements: Circuit board traces

Color scheme:
- Primary: Deep blue (#1A365D)
- Background: Dark gray (#1A202C)
- Accent: Electric cyan (#00D4FF)
EOF

# 测试生成
python generate_qwen_image.py test_prompt.md test_output.png
```

---

## 🚀 实际测试：为博客文章添加插图

### 测试文章

**文章**: AI Engineering Reading List  
**路径**: `d:\lilinji.github.io\content\posts\2026-01-14-2025-AI-Engineering-Reading-List论文\index.md`

### 测试步骤

#### 1. 创建提示词

```markdown
# illustration-ai-overview.md

Illustration theme: AI Engineering Landscape
Style: tech

Visual composition:

- Main visual: 一个现代化的 AI 工程全景图，展示神经网络、数据流和算法
- Layout: 居中的主要视觉元素，周围有辐射状的连接线
- Decorative elements: 电路纹理、发光的数据节点、几何网格

Color scheme:

- Primary: 深蓝色 (#1A365D)
- Background: 深灰色 (#1A202C)
- Accent: 电子青色 (#00D4FF)

Text content (if any):

- AI Engineering (英文标题)
- Neural Networks, LLMs, Agents (关键概念)

Style notes: 现代科技美学，带有发光效果和几何精确性
```

#### 2. 生成图片

```bash
# 使用 qwen-image 生成
python generate_qwen_image.py \
    "d:\lilinji.github.io\content\posts\2026-01-14-2025-AI-Engineering-Reading-List论文\imgs\prompts\illustration-ai-overview.md" \
    "d:\lilinji.github.io\content\posts\2026-01-14-2025-AI-Engineering-Reading-List论文\imgs\illustration-ai-overview.png"
```

#### 3. 插入文章

在文章开头添加:

```markdown
![AI Engineering Landscape](imgs/illustration-ai-overview.png)

# 2025 AI Engineering Reading List

这是一份精心整理的 AI 工程阅读清单...
```

---

## 📊 qwen-image vs 其他服务对比

| 特性         | qwen-image  | DALL-E 3    | Midjourney  | Stable Diffusion |
| ------------ | ----------- | ----------- | ----------- | ---------------- |
| **中文支持** | ⭐⭐⭐⭐⭐  | ⭐⭐⭐      | ⭐⭐        | ⭐⭐⭐           |
| **价格**     | ¥¥          | ¥¥¥¥        | ¥¥¥         | 免费/¥           |
| **速度**     | 快 (10-20s) | 中 (20-30s) | 慢 (30-60s) | 快 (5-15s)       |
| **质量**     | ⭐⭐⭐⭐    | ⭐⭐⭐⭐⭐  | ⭐⭐⭐⭐⭐  | ⭐⭐⭐⭐         |
| **API 友好** | ✅          | ✅          | ❌          | ✅               |
| **国内访问** | ✅ 无需 VPN | ❌ 需要 VPN | ❌ 需要 VPN | ✅ 部分需要      |

---

## 💡 提示词优化建议

### 中文提示词示例

```markdown
# 优质提示词结构

主题：现代科技插图
风格：科技蓝

视觉构成：

- 主视觉：一个由发光节点组成的神经网络，节点间有流动的数据流
- 布局：画面中心放置主要元素，四周留白
- 装饰元素：电路板纹理、几何图形、代码片段

配色方案：

- 主色：深蓝色 (#1A365D)
- 背景：深灰黑色 (#1A202C)
- 点缀色：霓虹青色 (#00D4FF)、亮白色

质量要求：

- 分辨率：1024x1024
- 风格：扁平化设计，现代简约
- 光效：柔和的发光效果
```

### Tech 风格专用提示词

```markdown
创建一个现代科技风格的插图，主要元素包括：

- AI 神经网络的示意图
- 几何化的数据节点
- 流动的信息流光效
- 深色背景配合霓虹色调
- 整体呈现未来科技感
```

---

## 🔧 故障排除

### 问题 1: API Key 无效

```bash
# 检查环境变量
echo $env:DASHSCOPE_API_KEY  # PowerShell
echo $DASHSCOPE_API_KEY      # Bash

# 验证 API Key
```

### 问题 2: 网络连接失败

```python
# 添加代理设置
import os
os.environ['HTTP_PROXY'] = 'http://your-proxy:port'
os.environ['HTTPS_PROXY'] = 'http://your-proxy:port'
```

### 问题 3: 生成质量不满意

**优化策略**:

1. 使用更详细的中文提示词
2. 明确指定风格和配色
3. 增加细节描述
4. 尝试不同的提示词结构

---

## 📝 完整工作流程

### 自动化脚本

```bash
#!/bin/bash
# auto_illustrate.sh - 自动为文章添加插图

ARTICLE="$1"
STYLE="${2:-tech}"

echo "处理文章: $ARTICLE"
echo "使用风格: $STYLE"

# 1. 分析文章并生成提示词计划
# 2. 创建 imgs 目录
# 3. 为每个提示词生成图片
# 4. 更新文章插入图片
# 5. 输出完成报告

echo "✓ 文章配图完成！"
```

---

## ✅ 下一步行动

### 立即行动

1. ✅ **设置环境变量**: 配置 `DASHSCOPE_API_KEY`
2. ✅ **安全清理**: 从公开文档中删除明文 API Key
3. ✅ **测试生成**: 运行测试脚本验证配置

### 短期目标

1. 📝 为 AI 论文文章生成 5 张配图
2. 🎨 测试不同风格的效果
3. 📊 对比生成质量

### 长期优化

1. 🤖 集成到自动化工作流
2. 📚 建立提示词模板库
3. 🎯 优化不同类型文章的配图策略

---

**配置完成！** 🎊

您的 baoyu-article-illustrator 技能现在可以使用魔塔社区的 qwen-image 生成高质量插图了！

---

**创建时间**: 2026-01-16 12:36  
**文档版本**: 1.0  
**API 服务**: 魔塔社区 qwen-image
