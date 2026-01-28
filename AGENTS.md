# Repository Guidelines

## Project Structure & Module Organization
- `content/` holds site content; posts live in `content/posts/YYYY-MM-DD-slug/index.md` with optional images beside the markdown.
- `assets/` contains custom CSS/JS; `layouts/` overrides theme templates.
- `static/` is for static files copied verbatim to the build output (e.g., `static/images/`).
- `themes/PaperMod/` is the Hugo theme (submodule or vendored).
- `public/` is generated output; do not edit by hand. `resources/` is Hugo cache.
- Hugo configuration is in `config.yaml`.

## Build, Test, and Development Commands
- `hugo server -D` runs the local dev server including drafts at `http://localhost:1313`.
- `hugo --minify --gc` builds a production site into `public/`.
- `./build.sh --serve` or `.\build.ps1 -Serve` runs the scripted build + local server.
- `./build.sh --clean` or `.\build.ps1 -Clean` clears `public/` before rebuilding.
- `.\deploy.ps1` or `./deploy.sh` commits and pushes for GitHub Pages (Actions also builds on `main`).

## Coding Style & Naming Conventions
- Use UTF-8 Markdown with YAML front matter. Prefer the repo’s date format: `YYYY-MM-DD HH:mm`.
- Posts use `content/posts/YYYY-MM-DD-slug/` with `index.md` and images in the same folder.
- Keep headings consistent (`#` for title, `##` for sections), and prefer short, descriptive filenames.
- Config and data files use 2-space indentation in YAML.

## Testing Guidelines
- No dedicated automated test suite is configured. If adding tests, use Playwright (`@playwright/test`)
  and place them under a `tests/` folder with a `playwright.config.*` plus npm scripts.

## Commit & Pull Request Guidelines
- Recent commits are short, descriptive, and often in Chinese; some use prefixes like `feat:` or `docs:`.
  Follow that pattern (e.g., `docs: update post images` or `修复xx文章排版`).
- PRs should include a brief description, link any related issues, and add screenshots for visual changes.
- Confirm `hugo server -D` renders correctly and that `public/` is not committed.

## Content Authoring Tips
- Use the helper scripts: `create_post.ps1`, `create_post.sh`, or `create_post.py` to scaffold new posts.
- Set `draft: false` only when ready to publish; keep images referenced with relative paths.
