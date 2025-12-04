#!/usr/bin/env pwsh
# Deploy to GitHub Pages
# Usage: .\deploy.ps1 [-Message "commit message"]

param(
    [string]$Message = "Deploy site $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
)

Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host ("=" * 69) -ForegroundColor Cyan
Write-Host "Deploy to GitHub Pages" -ForegroundColor Yellow
Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host ("=" * 69) -ForegroundColor Cyan
Write-Host ""

# 不再检查 public 目录或 index.html，部署整个仓库（遵循 .gitignore）

Write-Host "📦 Step 1: Preparing deployment..." -ForegroundColor Cyan
Write-Host "   - Commit message: $Message" -ForegroundColor White
Write-Host ""

# 在仓库根目录进行部署（不切换目录）

try {
    # 初始化 git (如果需要)
    if (-not (Test-Path ".git")) {
        Write-Host "🔧 Initializing git repository..." -ForegroundColor Cyan
        git init
        git branch -M main
        Write-Host "✅ Git initialized" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "📝 Step 2: Staging files..." -ForegroundColor Cyan
    
    # 添加所有文件
    git add -A
    
    $changes = git status --short
    if ($changes) {
        Write-Host "✅ Files staged:" -ForegroundColor Green
        Write-Host $changes -ForegroundColor Gray
    }
    else {
        Write-Host "⚠️  No changes to deploy" -ForegroundColor Yellow
        exit 0
    }
    
    Write-Host ""
    Write-Host "💾 Step 3: Committing changes..." -ForegroundColor Cyan
    
    git commit -m $Message
    Write-Host "✅ Changes committed" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "🚀 Step 4: Pushing to GitHub..." -ForegroundColor Cyan
    Write-Host "   - Repository: https://github.com/lilinji/lilinji.github.io" -ForegroundColor White
    Write-Host "   - Branch: main" -ForegroundColor White
    Write-Host ""
    
    # 推送到 GitHub (强制推送以替换所有内容)
    git push -f https://github.com/lilinji/lilinji.github.io.git main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "=" -NoNewline -ForegroundColor Cyan
        Write-Host ("=" * 69) -ForegroundColor Cyan
        Write-Host "✨ Deployment Successful!" -ForegroundColor Green
        Write-Host "=" -NoNewline -ForegroundColor Cyan
        Write-Host ("=" * 69) -ForegroundColor Cyan
        Write-Host ""
        Write-Host "🌐 Your site will be available at:" -ForegroundColor Yellow
        Write-Host "   https://lilinji.github.io" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "⏱️  Note: GitHub Pages may take a few minutes to update" -ForegroundColor Gray
        Write-Host ""
    }
    else {
        Write-Host "❌ Push failed" -ForegroundColor Red
        Write-Host "   Please check your GitHub credentials and repository access" -ForegroundColor Yellow
        exit 1
    }
    
}
catch {
    Write-Host "❌ Deployment error: $_" -ForegroundColor Red
    exit 1
}

# 保持在仓库根目录

Write-Host "📊 Deployment Summary:" -ForegroundColor Cyan
Write-Host "   - Commit: $Message" -ForegroundColor White
Write-Host "   - Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor White
Write-Host ""
