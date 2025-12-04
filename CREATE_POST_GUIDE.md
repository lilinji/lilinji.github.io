# 快速创建文章脚本使用指南

## 功能说明

`create_post` 脚本可以快速创建带有预设 front matter 的新文章,自动生成目录和模板内容。

## 使用方法

### 方法 1: Windows (.bat 文件)

```cmd
create_post "文章标题" ["标签1,标签2"]
```

### 方法 2: PowerShell (.ps1 文件)

```powershell
powershell -ExecutionPolicy Bypass -File create_post.ps1 "文章标题" "标签1,标签2"
```

### 方法 3: Bash (.sh 文件) - Linux/macOS

```bash
# 添加执行权限
chmod +x create_post.sh

# 运行脚本
./create_post.sh "文章标题" "标签1,标签2"
```

### 方法 4: Python (.py 文件) - 跨平台

```bash
python create_post.py "文章标题" "标签1,标签2"
```

## 生成的文件结构

```
content/posts/YYYY-MM-DD-文章标题/
└── index.md
```

## Front Matter 格式

生成的文章包含以下 front matter:

```yaml
---
title: 文章标题
date: 2025-12-04 09:31        # 简洁的日期时间格式
draft: false
tags:
- AI
- DeepLearning
author: Ringi Lee
showToc: true
tocOpen: false
---
```

## 日期格式说明

**新格式** (更易读):
- `date: 2025-12-04 09:31`
- 格式: `YYYY-MM-DD HH:mm`

**旧格式** (ISO 8601):
- `date: 2025-12-04T09:31:00+08:00`

Hugo 两种格式都支持,新格式更简洁易读。

## 文章模板

脚本会自动生成包含以下结构的模板:

```markdown
# 文章标题

## 简介

在这里开始写作...

## 主要内容

### 小节 1

内容...

### 小节 2

内容...

## 总结

总结内容...

## 参考资料

- [参考链接1](https://example.com)
- [参考链接2](https://example.com)
```

## 自定义配置

编辑 `create_post.ps1` 修改默认配置:

```powershell
# 默认作者
$Author = "Ringi Lee"

# 默认标签
[string]$Tags = "AI,DeepLearning"

# 内容目录
$ContentDir = "content/posts"
```

## 工作流程

1. **创建文章**:
   ```cmd
   create_post "我的新文章" "Tag1,Tag2"
   ```

2. **编辑内容**:
   打开生成的 `index.md` 文件编辑

3. **添加图片**:
   将图片放在文章目录下,使用相对路径引用:
   ```markdown
   ![图片描述](image.png)
   ```

4. **预览**:
   ```bash
   hugo server -D
   ```

5. **发布**:
   将 `draft: false` 改为 `draft: true` (如果需要)

## 常见问题

**Q: 如何修改默认标签?**

A: 编辑 `create_post.ps1`,修改 `$Tags` 变量的默认值。

**Q: 可以不指定标签吗?**

A: 可以,脚本会使用默认标签 `AI,DeepLearning`。

**Q: 日期格式可以自定义吗?**

A: 可以,编辑脚本中的 `Get-Date -Format "yyyy-MM-dd HH:mm"` 部分。

**Q: 如何批量创建文章?**

A: 创建一个循环脚本:
```powershell
$titles = @("文章1", "文章2", "文章3")
foreach ($title in $titles) {
    .\create_post.ps1 $title "Tag1,Tag2"
}
```

## 高级用法

### 创建特定日期的文章

修改脚本中的日期生成部分:

```powershell
# 使用特定日期
$Date = "2024-12-01"
$DateTime = "2024-12-01 10:00"
```

### 添加更多 Front Matter 字段

在脚本的 `$FrontMatter` 部分添加:

```powershell
$FrontMatter = @"
---
title: $Title
date: $DateTime
draft: false
tags:
$TagsYamlString
categories: ["技术"]          # 新增
description: "文章描述"        # 新增
author: $Author
showToc: true
tocOpen: false
---
"@
```

## 故障排除

**错误: 目录已存在**
- 原因: 同一天已创建同名文章
- 解决: 修改标题或删除已存在的目录

**错误: 权限不足**
- 原因: PowerShell 执行策略限制
- 解决: 使用 `-ExecutionPolicy Bypass` 参数

**乱码问题**
- 原因: 编码问题
- 解决: 确保脚本和文件都使用 UTF-8 编码

---

**创建时间**: 2025-12-04  
**脚本版本**: 1.0  
**兼容性**: Windows PowerShell 5.1+
