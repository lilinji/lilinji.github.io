# Project Cleanup Script
# 清理 Hugo 项目中的构建输出和临时文件

Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host ("=" * 69) -ForegroundColor Cyan
Write-Host "Hugo Project Cleanup" -ForegroundColor Yellow
Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host ("=" * 69) -ForegroundColor Cyan
Write-Host ""

# 设置错误处理
$ErrorActionPreference = "Continue"

# 统计
$deletedDirs = 0
$deletedFiles = 0
$errors = 0

# 函数: 删除目录
function Remove-Directory {
    param($Path, $Name)
    
    if (Test-Path $Path) {
        try {
            Remove-Item -Path $Path -Recurse -Force
            Write-Host "✅ Deleted directory: $Name" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "❌ Failed to delete: $Name - $_" -ForegroundColor Red
            $script:errors++
            return $false
        }
    }
    else {
        Write-Host "⚠️  Not found: $Name" -ForegroundColor Yellow
        return $false
    }
}

# 函数: 删除文件
function Remove-FileIfExists {
    param($Path, $Name)
    
    if (Test-Path $Path) {
        try {
            Remove-Item -Path $Path -Force
            Write-Host "✅ Deleted file: $Name" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "❌ Failed to delete: $Name - $_" -ForegroundColor Red
            $script:errors++
            return $false
        }
    }
    else {
        Write-Host "⚠️  Not found: $Name" -ForegroundColor Yellow
        return $false
    }
}

Write-Host "`n📦 Phase 1: Removing Hugo Build Outputs" -ForegroundColor Cyan
Write-Host ("-" * 70) -ForegroundColor Gray

# 删除构建输出目录
if (Remove-Directory "posts" "posts/") { $deletedDirs++ }
if (Remove-Directory "tags" "tags/") { $deletedDirs++ }
if (Remove-Directory "page" "page/") { $deletedDirs++ }

# 删除构建输出文件
if (Remove-FileIfExists "index.html" "index.html") { $deletedFiles++ }
if (Remove-FileIfExists "index.json" "index.json") { $deletedFiles++ }
if (Remove-FileIfExists "index.xml" "index.xml") { $deletedFiles++ }
if (Remove-FileIfExists "sitemap.xml" "sitemap.xml") { $deletedFiles++ }
if (Remove-FileIfExists "robots.txt" "robots.txt") { $deletedFiles++ }
if (Remove-FileIfExists "404.html" "404.html") { $deletedFiles++ }

Write-Host "`n🔧 Phase 2: Removing Temporary Scripts" -ForegroundColor Cyan
Write-Host ("-" * 70) -ForegroundColor Gray

if (Remove-FileIfExists "update_date_format.py" "update_date_format.py") { $deletedFiles++ }
if (Remove-FileIfExists "fix_date_format.py" "fix_date_format.py") { $deletedFiles++ }

Write-Host "`n📝 Phase 3: Removing Example Files" -ForegroundColor Cyan
Write-Host ("-" * 70) -ForegroundColor Gray

if (Remove-Directory "content\posts\2024-12-03-example-post" "example-post/") { $deletedDirs++ }
if (Remove-Directory "content\posts\2024-12-03-my-article" "my-article/") { $deletedDirs++ }
if (Remove-FileIfExists "example-update.png" "example-update.png") { $deletedFiles++ }

# 打印总结
Write-Host "`n" -NoNewline
Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host ("=" * 69) -ForegroundColor Cyan
Write-Host "Cleanup Summary" -ForegroundColor Yellow
Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host ("=" * 69) -ForegroundColor Cyan

Write-Host "Directories deleted: $deletedDirs" -ForegroundColor Green
Write-Host "Files deleted:       $deletedFiles" -ForegroundColor Green
Write-Host "Errors:              $errors" -ForegroundColor $(if ($errors -eq 0) { "Green" } else { "Red" })

Write-Host "`n" -NoNewline
Write-Host "=" -NoNewline -ForegroundColor Cyan
Write-Host ("=" * 69) -ForegroundColor Cyan

if ($errors -eq 0) {
    Write-Host "✨ Cleanup completed successfully!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Yellow
    Write-Host "1. Update .gitignore file" -ForegroundColor White
    Write-Host "2. Run: hugo --gc" -ForegroundColor White
    Write-Host "3. Run: hugo server -D" -ForegroundColor White
    Write-Host "4. Verify: http://localhost:1313" -ForegroundColor White
}
else {
    Write-Host "⚠️  Cleanup completed with $errors error(s)" -ForegroundColor Yellow
    Write-Host "Please review the errors above" -ForegroundColor White
}

Write-Host ""
