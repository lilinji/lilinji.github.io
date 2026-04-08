# Task Plan: Obsidian to Blog Post + Reusable Skill

## Goal
将 Obsidian Clippings 文章发布为 Hugo 博客，并创建可复用的 skill 实现自动化流程。

## Current Phase
Phase 4

## Phases

### Phase 1: Requirements & Discovery
- [x] 读取 Obsidian 文章内容
- [x] 理解 Hugo 博客结构和 frontmatter 格式
- [x] 确认图片处理策略（URL 保持不变）
- **Status:** complete

### Phase 2: Planning & Structure
- [x] 确定 frontmatter 转换规则：Obsidian → Hugo
- [x] 确定文件路径：`content/posts/YYYY-MM-DD-slug/index.md`
- [x] 确定 skill 结构
- **Status:** complete

### Phase 3: Implementation
- [x] 创建博客文章：`content/posts/2026-04-08-搞懂缓存机制从Gemma4到Claude-Code省80Token/index.md`
- [x] 创建 obsidian-to-blog skill：`.agent/skills/obsidian-to-blog/SKILL.md`
- **Status:** complete

### Phase 4: Testing & Verification
- [ ] 运行 `hugo server -D` 验证（需用户手动执行，sandbox 限制）
- [x] 验证 skill 文档完整
- [x] 验证博客文章结构和内容正确
- **Status:** in_progress

## Decisions Made
| Decision | Rationale |
|----------|-----------|
| 图片 URL 保持不变 | 文章图片均为 Twitter CDN 链接（3张），无需下载 |
| 标签使用 "AI相关" | 用户指定 |
| Skill 放在 `.agent/skills/` | 项目级别 skill，跟随仓库 |
| Frontmatter 转换 | Obsidian source→原文来源引用块，author→清理wiki链接，tags→用户指定 |
| Obsidian 语法清理 | [[@username]] → @username，移除 clippings 标签 |
