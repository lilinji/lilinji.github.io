# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Hugo-based blog using the PaperMod theme, deployed to GitHub Pages. The blog covers AI/ML technologies, cloud computing (OpenStack, Docker, Ceph), and Linux operations.

## Build Commands

```bash
# Local development server (includes drafts)
hugo server -D

# Production build
hugo --minify --gc

# Scripts (add +x first time)
./build.sh --serve    # build + local server
./build.sh --clean    # clear public/ before rebuild
./deploy.sh           # commit and push to GitHub
```

## Content Structure

**Posts location:** `content/posts/YYYY-MM-DD-slug/index.md`

**Article images:** Each post can have an `imgs/` or `images/` subdirectory for local images.

```yaml
---
title: "Article Title"
date: 2026-04-03T00:00:00+08:00
draft: false
tags:
  - AI相关
  - 大模型
author: Ringi Lee
showToc: true
tocOpen: false
---
```

**Image references in markdown:**
```markdown
![Description](imgs/image-name.jpg)
```

## Obsidian Migration Skill

Use the `obsidian-to-blog` skill to migrate articles from Obsidian Vault to this blog.

**Activation phrases:**
- "迁移文章" / "migrate" / "convert to blog"
- obsidian:// URLs
- Batch migration requests

**What it does:**
- Converts Obsidian frontmatter to Hugo format
- Downloads remote images to `images/` subdirectory
- Transforms Wiki links (`[[note]]`) to Markdown links
- Expands tags intelligently (e.g., `clippings` → `AI相关, 翻译`)
- Adds source quote block at article end

**Example:**
```
帮我迁移这篇文章：/Users/ringi/Documents/Obsidian Vault/Clippings/xxx.md
```

## Commit Style

Recent commits use descriptive Chinese messages with optional prefixes:
- `feat:`, `docs:`, `fix:`

Example: `docs: 添加 Obsidian 文章迁移功能`

## Architecture

```
content/posts/YYYY-MM-DD-slug/
├── index.md          # Article content
├── imgs/            # Article images (legacy)
└── images/          # Article images (new convention)
```

**Hugo config:** `hugo.yaml` (not `config.yaml` as mentioned in some docs)

**Theme:** PaperMod (submodule at `themes/PaperMod/`)

**Do NOT edit:**
- `public/` (generated output)
- `resources/` (Hugo cache)
