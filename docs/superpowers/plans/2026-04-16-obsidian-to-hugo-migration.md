# Obsidian Clipping to Hugo Blog Migration Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a Hugo blog post from an Obsidian clipping, properly formatted with frontmatter, downloaded images, and cleaned content.

**Architecture:** Manual process combining Obsidian file reading, content transformation, image downloading, and Hugo post scaffold creation via create_post script.

**Tech Stack:** PowerShell/Bash, Hugo, Obsidian markdown, Twitter/X image URLs

---

## File Structure

```
content/posts/2026-04-16-使用-Claude-Code-会话管理与-100-万-上下文-译/
├── index.md          # Transformed Hugo post
└── images/           # Downloaded Twitter/X images
```

**Key transformations needed:**
- Obsidian `![Image](https://pbs.twimg.com/...)` → Hugo `![](images/filename.jpg)`
- Obsidian frontmatter → Hugo frontmatter with proper tags
- Wiki links `[[note]]` → Markdown links (if any exist)
- Download remote Twitter images to `images/` subdirectory

---

## Task 1: Create Hugo Post Scaffold

**Files:**
- Create: `content/posts/2026-04-16-使用-Claude-Code-会话管理与-100-万-上下文-译/index.md`
- Modify: (none)
- Test: (none)

- [ ] **Step 1: Run create_post.ps1 with extracted title and tags**

```powershell
.\create_post.ps1 "使用 Claude Code：会话管理与 100 万 上下文【译】" "AI相关,Claude,翻译"
```

Expected output: Creates directory `content/posts/2026-04-16-使用-Claude-Code-会话管理与-100-万-上下文-译/` with `index.md` containing basic frontmatter.

---

## Task 2: Create images/ Subdirectory

**Files:**
- Create: `content/posts/2026-04-16-使用-Claude-Code-会话管理与-100-万-上下文-译/images/`

- [ ] **Step 1: Create images directory**

```powershell
New-Item -ItemType Directory -Path "content/posts/2026-04-16-使用-Claude-Code-会话管理与-100-万-上下文-译/images" -Force
```

---

## Task 3: Download Twitter/X Images

**Files:**
- Modify: (downloads to `images/` subdirectory)
- Test: Verify images exist

**Source images from Obsidian file:**
1. `https://pbs.twimg.com/media/HF-_JDXXsAIk1QU?format=jpg&name=large`
2. `https://pbs.twimg.com/media/HF-_L6XWEAAMrZL?format=jpg&name=large`
3. `https://pbs.twimg.com/media/HF-_PVXX0AArbH1?format=jpg&name=large`
4. `https://pbs.twimg.com/media/HF-_S8JWkAEfgNZ?format=jpg&name=large`
5. `https://pbs.twimg.com/media/HF-_WS_XoAAsUzP?format=jpg&name=large`
6. `https://pbs.twimg.com/media/HF-_ZYUXsAADOii?format=jpg&name=large`
7. `https://pbs.twimg.com/media/HF-_cYXXsAADokV?format=jpg&name=large`
8. `https://pbs.twimg.com/media/HF-_fxUW4AANXqF?format=jpg&name=large`
9. `https://pbs.twimg.com/media/HF-_jOObEAMsRLB?format=jpg&name=large`
10. `https://pbs.twimg.com/media/HF-_mPmW8AAAHGO?format=jpg&name=large`

- [ ] **Step 1: Download all Twitter/X images with descriptive filenames**

```powershell
$baseDir = "content/posts/2026-04-16-使用-Claude-Code-会话管理与-100-万-上下文-译/images"
$images = @(
    @{url="https://pbs.twimg.com/media/HF-_JDXXsAIk1QU?format=jpg&name=large"; name="context-window-intro.jpg"},
    @{url="https://pbs.twimg.com/media/HF-_L6XWEAAMrZL?format=jpg&name=large"; name="context-rot-explainer.jpg"},
    @{url="https://pbs.twimg.com/media/HF-_PVXX0AArbH1?format=jpg&name=large"; name="session-options.jpg"},
    @{url="https://pbs.twimg.com/media/HF-_S8JWkAEfgNZ?format=jpg&name=large"; name="new-session-timing.jpg"},
    @{url="https://pbs.twimg.com/media/HF-_WS_XoAAsUzP?format=jpg&name=large"; name="rewind-explainer.jpg"},
    @{url="https://pbs.twimg.com/media/HF-_ZYUXsAADOii?format=jpg&name=large"; name="compact-vs-clear.jpg"},
    @{url="https://pbs.twimg.com/media/HF-_cYXXsAADokV?format=jpg&name=large"; name="compact-failure.jpg"},
    @{url="https://pbs.twimg.com/media/HF-_fxUW4AANXqF?format=jpg&name=large"; name="subagents-intro.jpg"},
    @{url="https://pbs.twimg.com/media/HF-_jOObEAMsRLB?format=jpg&name=large"; name="subagents-uses.jpg"},
    @{url="https://pbs.twimg.com/media/HF-_mPmW8AAAHGO?format=jpg&name=large"; name="summary-visual.jpg"}
)
foreach ($img in $images) {
    Invoke-WebRequest -Uri $img.url -OutFile "$baseDir/$($img.name)"
}
```

---

## Task 4: Transform Content and Write Hugo Post

**Files:**
- Modify: `content/posts/2026-04-16-使用-Claude-Code-会话管理与-100-万-上下文-译/index.md`

**Content transformation rules:**
1. Replace Obsidian `![Image](url)` with `![](images/filename.jpg)` using mapped names
2. Clean up any wiki links `[[note]]` → convert to Markdown links
3. Preserve Chinese content structure with proper h2/h3 headings
4. Add source attribution blockquote at end (from frontmatter source field)
5. Remove Obsidian-specific frontmatter, use Hugo frontmatter format

**Image mapping:**
| Original URL | Local filename |
|-------------|----------------|
| HF-_JDXXsAIk1QU | context-window-intro.jpg |
| HF-_L6XWEAAMrZL | context-rot-explainer.jpg |
| HF-_PVXX0AArbH1 | session-options.jpg |
| HF-_S8JWkAEfgNZ | new-session-timing.jpg |
| HF-_WS_XoAAsUzP | rewind-explainer.jpg |
| HF-_ZYUXsAADOii | compact-vs-clear.jpg |
| HF-_cYXXsAADokV | compact-failure.jpg |
| HF-_fxUW4AANXqF | subagents-intro.jpg |
| HF-_jOObEAMsRLB | subagents-uses.jpg |
| HF-_mPmW8AAAHGO | summary-visual.jpg |

- [ ] **Step 1: Write transformed Hugo frontmatter and content**

```markdown
---
title: "使用 Claude Code：会话管理与 100 万 上下文【译】"
date: 2026-04-16T00:00:00+08:00
draft: false
tags:
- AI相关
- Claude
- 翻译
author: Ringi Lee
showToc: true
tocOpen: false
source: "https://x.com/dotey/status/2044563867355754900"
---

# 使用 Claude Code：会话管理与 100 万 上下文【译】

![上下文窗口介绍](images/context-window-intro.jpg)

今天，我们为 **/usage** 命令推出了一项全新更新，旨在帮助你更清晰地了解自己在 Claude Code 中的使用情况...

[... full transformed content ...]

---

> **来源**: [https://x.com/dotey/status/2044563867355754900](https://x.com/dotey/status/2044563867355754900)
```

---

## Task 5: Verify Hugo Build

**Files:**
- Test: `hugo server -D` or `hugo --minify --gc`

- [ ] **Step 1: Verify the post renders correctly**

```powershell
hugo server -D
```

Navigate to `http://localhost:1313` and verify the post appears with correct formatting and images.
