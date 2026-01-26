---
description: 将文章/文本转换为带插图、字幕和BGM的视频
---

# /article-to-video 工作流

将长文/文章自动转换为2-3分钟精华视频，适用于B站/YouTube。

// turbo-all

## 使用方法

提供文章内容，Antigravity会自动执行以下步骤：

## 工作流程

### 1. 分析文章并生成脚本

Agent会自动：

- 提取6-8个核心场景
- 为每个场景编写精简旁白（15-25秒）
- 生成视频脚本表格

**用户确认**: 脚本和插图风格

### 2. 生成AI插图

使用 `generate_image` 工具为每个场景生成温馨水彩风格插图。

Prompt模板:

```
Warm watercolor illustration, 16:9 aspect ratio, Japanese anime style.
[场景描述]. Soft warm colors (cream, pale orange, warm yellow).
[情感氛围]. No faces visible (silhouette/back view preferred).
```

### 3. 创建字幕文件

生成SRT格式字幕：

```powershell
# 字幕内容通过PowerShell here-string写入
@"
1
00:00:00,000 --> 00:00:15,000
字幕内容...
"@ | Out-File -FilePath "subtitles.srt" -Encoding UTF8
```

### 4. 下载背景音乐

从Pixabay下载免费BGM：

```powershell
Invoke-WebRequest -Uri "https://cdn.pixabay.com/download/audio/..." -OutFile "bgm.mp3"
```

推荐曲目类型：Lofi Study, Peaceful Piano, Healing Journey

### 5. 合成最终视频

使用ffmpeg合成：

```powershell
# Step 1: 图片转视频
ffmpeg -y -framerate 1/15 -i scene1.png -framerate 1/20 -i scene2.png ... \
  -filter_complex "...,concat=n=8:v=1:a=0[out]" \
  -map "[out]" -c:v libx264 -preset fast -crf 20 "temp.mp4"

# Step 2: 添加字幕+音乐
ffmpeg -y -i "temp.mp4" -i bgm.mp3 \
  -vf "subtitles=subtitles.srt:force_style='FontName=Microsoft YaHei,FontSize=24,...'" \
  -c:v libx264 -c:a aac -b:a 128k -shortest "final.mp4"
```

### 6. 输出

最终生成：

- `{title}_完整版.mp4` - 带字幕+BGM的完整视频
- `subtitles.srt` - 字幕文件（可单独导入剪辑软件）
- `*.png` - 各场景插图（可单独使用）

## 参数说明

| 参数     | 默认值      | 说明                 |
| -------- | ----------- | -------------------- |
| 时长     | 2-3分钟     | 视频总时长           |
| 分辨率   | 1920x1080   | 16:9横屏             |
| 插图风格 | 温馨水彩    | 可选：扁平/赛博/复古 |
| 平台     | B站/YouTube | 横屏16:9             |

## 技能位置

`d:\lilinji.github.io\.agent\skills\article-to-video\SKILL.md`
