# Hugo 项目快速设置脚本 (PowerShell)

Write-Host "=== Hugo 项目设置脚本 ===" -ForegroundColor Green
Write-Host ""

# 检查 Hugo 是否安装
Write-Host "检查 Hugo 安装..." -ForegroundColor Yellow
try {
    $hugoVersion = hugo version
    Write-Host "✓ Hugo 已安装: $hugoVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Hugo 未安装" -ForegroundColor Red
    Write-Host "请先安装 Hugo Extended: https://gohugo.io/installation/" -ForegroundColor Yellow
    exit 1
}

# 检查 Git 是否安装
Write-Host "检查 Git 安装..." -ForegroundColor Yellow
try {
    $gitVersion = git --version
    Write-Host "✓ Git 已安装: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Git 未安装" -ForegroundColor Red
    Write-Host "请先安装 Git: https://git-scm.com/downloads" -ForegroundColor Yellow
    exit 1
}

# 安装主题
Write-Host ""
Write-Host "安装 PaperMod 主题..." -ForegroundColor Yellow

if (Test-Path "themes/PaperMod") {
    Write-Host "✓ 主题已存在，跳过安装" -ForegroundColor Green
} else {
    Write-Host "正在克隆主题..." -ForegroundColor Yellow
    git clone --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ 主题安装成功" -ForegroundColor Green
    } else {
        Write-Host "✗ 主题安装失败" -ForegroundColor Red
        exit 1
    }
}

# 创建必要的目录
Write-Host ""
Write-Host "创建目录结构..." -ForegroundColor Yellow

$directories = @(
    "content/posts",
    "static/images",
    "static/css"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "✓ 创建目录: $dir" -ForegroundColor Green
    } else {
        Write-Host "✓ 目录已存在: $dir" -ForegroundColor Gray
    }
}

# 复制静态资源（如果存在）
Write-Host ""
Write-Host "检查静态资源..." -ForegroundColor Yellow

$staticFiles = @(
    "favicon_wine.ico",
    "favicon_peach.ico"
)

foreach ($file in $staticFiles) {
    if (Test-Path $file) {
        if (-not (Test-Path "static/$file")) {
            Copy-Item $file "static/$file"
            Write-Host "✓ 复制文件: $file" -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "=== 设置完成 ===" -ForegroundColor Green
Write-Host ""
Write-Host "下一步操作:" -ForegroundColor Cyan
Write-Host "1. 启动开发服务器: hugo server -D" -ForegroundColor White
Write-Host "2. 访问 http://localhost:1313 查看网站" -ForegroundColor White
Write-Host "3. 创建新文章: hugo new posts/2024-12-03-title/index.md" -ForegroundColor White
Write-Host ""

