#!/usr/bin/env pwsh
# Hugo Build Script - 自动清理并构建最新版本
# Usage: .\build.ps1 [-Clean] [-Minify] [-Serve]

param(
    [switch]$Clean = $false,
    [switch]$Minify = $true,
    [switch]$Serve = $false
)

Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host ("=" * 69) -ForegroundColor Cyan
Write-Host "Hugo Build Script" -ForegroundColor Yellow
Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host ("=" * 69) -ForegroundColor Cyan
Write-Host ""

# 步骤 1: 清理 (可选)
if ($Clean) {
    Write-Host "📦 Step 1: Cleaning public directory..." -ForegroundColor Cyan
    if (Test-Path "public") {
        Remove-Item -Recurse -Force "public"
        Write-Host "✅ Cleaned public directory" -ForegroundColor Green
    }
    else {
        Write-Host "⚠️  public directory not found, skipping" -ForegroundColor Yellow
    }
    Write-Host ""
}

# 步骤 2: 构建
Write-Host "🔨 Step 2: Building site..." -ForegroundColor Cyan

$buildArgs = @()
$buildArgs += "--gc"  # 清理缓存

if ($Minify) {
    $buildArgs += "--minify"
    Write-Host "   - Minification: Enabled" -ForegroundColor White
}

Write-Host "   - Running: hugo $($buildArgs -join ' ')" -ForegroundColor White

try {
    $output = & hugo $buildArgs 2>&1
    
    # 检查是否成功
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Build completed successfully" -ForegroundColor Green
        
        # 解析输出统计
        $output | Select-String -Pattern "Pages|Static files|Total in" | ForEach-Object {
            Write-Host "   $_" -ForegroundColor Gray
        }
    }
    else {
        Write-Host "❌ Build failed" -ForegroundColor Red
        Write-Host $output -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "❌ Build error: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# 步骤 3: 验证
Write-Host "🔍 Step 3: Verifying build..." -ForegroundColor Cyan

if (Test-Path "public/index.html") {
    $publicSize = (Get-ChildItem -Path "public" -Recurse | Measure-Object -Property Length -Sum).Sum
    $publicSizeMB = [math]::Round($publicSize / 1MB, 2)
    
    Write-Host "✅ Build verified" -ForegroundColor Green
    Write-Host "   - Output directory: public/" -ForegroundColor White
    Write-Host "   - Total size: $publicSizeMB MB" -ForegroundColor White
    
    # 统计文件数量
    $htmlFiles = (Get-ChildItem -Path "public" -Filter "*.html" -Recurse).Count
    $cssFiles = (Get-ChildItem -Path "public" -Filter "*.css" -Recurse).Count
    $jsFiles = (Get-ChildItem -Path "public" -Filter "*.js" -Recurse).Count
    
    Write-Host "   - HTML files: $htmlFiles" -ForegroundColor White
    Write-Host "   - CSS files: $cssFiles" -ForegroundColor White
    Write-Host "   - JS files: $jsFiles" -ForegroundColor White
}
else {
    Write-Host "❌ Build verification failed: index.html not found" -ForegroundColor Red
    exit 1
}

Write-Host ""

# 步骤 4: 启动服务器 (可选)
if ($Serve) {
    Write-Host "🚀 Step 4: Starting development server..." -ForegroundColor Cyan
    Write-Host "   - Press Ctrl+C to stop" -ForegroundColor Yellow
    Write-Host ""
    
    & hugo server -D
}
else {
    Write-Host "✨ Build complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Preview: hugo server -D" -ForegroundColor White
    Write-Host "2. Deploy: Upload public/ directory" -ForegroundColor White
    Write-Host "3. Or run: .\build.ps1 -Serve" -ForegroundColor White
}

Write-Host ""
