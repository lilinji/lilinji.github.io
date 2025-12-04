#!/usr/bin/env pwsh
# Create New Post Script for Hugo Blog
# Usage: .\create_post.ps1 "文章标题" ["tag1,tag2"]

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Title,
    
    [Parameter(Mandatory = $false, Position = 1)]
    [string]$Tags = "AI,DeepLearning"
)

# 配置
$Author = "Ringi Lee"
$ContentDir = "content/posts"

# 获取当前日期和时间 - 使用 ISO 8601 格式
$Date = Get-Date -Format "yyyy-MM-dd"
$DateTime = Get-Date -Format "yyyy-MM-ddTHH:mm:ss+08:00"

# 生成文件名友好的 slug
$Slug = $Title -replace '\s+', '-' `
    -replace '[^\w\-\u4e00-\u9fa5]', '' `
    -replace '-+', '-' `
    -replace '^-|-$', ''

# 创建目录名
$DirName = "$Date-$Slug"
$PostDir = Join-Path $ContentDir $DirName

# 检查目录是否已存在
if (Test-Path $PostDir) {
    Write-Host "❌ 错误: 目录已存在: $PostDir" -ForegroundColor Red
    exit 1
}

# 创建目录
try {
    New-Item -ItemType Directory -Path $PostDir -Force | Out-Null
    Write-Host "✅ 创建目录: $PostDir" -ForegroundColor Green
}
catch {
    Write-Host "❌ 创建目录失败: $_" -ForegroundColor Red
    exit 1
}

# 处理标签
$TagArray = $Tags -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
$TagsYaml = ($TagArray | ForEach-Object { "- $_" }) -join "`n"

# 生成 front matter - 直接使用英文避免编码问题
$FrontMatter = "---`n"
$FrontMatter += "title: $Title`n"
$FrontMatter += "date: $DateTime`n"
$FrontMatter += "draft: false`n"
$FrontMatter += "tags:`n"
$FrontMatter += "$TagsYaml`n"
$FrontMatter += "author: $Author`n"
$FrontMatter += "showToc: true`n"
$FrontMatter += "tocOpen: false`n"
$FrontMatter += "---`n"
$FrontMatter += "`n"
$FrontMatter += "# $Title`n"
$FrontMatter += "`n"
$FrontMatter += "## Introduction`n"
$FrontMatter += "`n"
$FrontMatter += "Start writing here...`n"
$FrontMatter += "`n"
$FrontMatter += "## Main Content`n"
$FrontMatter += "`n"
$FrontMatter += "### Section 1`n"
$FrontMatter += "`n"
$FrontMatter += "Content...`n"
$FrontMatter += "`n"
$FrontMatter += "### Section 2`n"
$FrontMatter += "`n"
$FrontMatter += "Content...`n"
$FrontMatter += "`n"
$FrontMatter += "## Summary`n"
$FrontMatter += "`n"
$FrontMatter += "Summary content...`n"
$FrontMatter += "`n"
$FrontMatter += "## References`n"
$FrontMatter += "`n"
$FrontMatter += "- [Reference 1](https://example.com)`n"
$FrontMatter += "- [Reference 2](https://example.com)`n"

# 写入文件 - 使用 UTF8 without BOM
$IndexFile = Join-Path $PostDir "index.md"
try {
    # 使用 UTF8 without BOM 编码
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllText($IndexFile, $FrontMatter, $Utf8NoBomEncoding)
    Write-Host "✅ 创建文件: $IndexFile" -ForegroundColor Green
}
catch {
    Write-Host "❌ 创建文件失败: $_" -ForegroundColor Red
    exit 1
}

# 打印摘要
Write-Host "`n" -NoNewline
Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host ("=" * 69) -ForegroundColor Cyan
Write-Host "Article Created Successfully!" -ForegroundColor Yellow
Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host ("=" * 69) -ForegroundColor Cyan
Write-Host ""
Write-Host "Title:     $Title" -ForegroundColor White
Write-Host "Date:      $DateTime" -ForegroundColor White
Write-Host "Directory: $PostDir" -ForegroundColor White
Write-Host "Tags:      $($TagArray -join ', ')" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Edit file: $IndexFile" -ForegroundColor White
Write-Host "2. Add images to: $PostDir" -ForegroundColor White
Write-Host "3. Preview: hugo server -D" -ForegroundColor White
Write-Host ""
