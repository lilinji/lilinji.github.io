@echo off
REM Create New Post Batch Script
REM Usage: create_post.bat "文章标题" ["tag1,tag2"]

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo 错误: 请提供文章标题
    echo 用法: create_post.bat "文章标题" ["标签1,标签2"]
    echo 示例: create_post.bat "AI技术大全" "AI,DeepLearning"
    exit /b 1
)

set "TITLE=%~1"
set "TAGS=%~2"

if "%TAGS%"=="" (
    set "TAGS=AI,DeepLearning"
)

REM 调用 PowerShell 脚本
powershell -ExecutionPolicy Bypass -File "%~dp0create_post.ps1" "%TITLE%" "%TAGS%"
