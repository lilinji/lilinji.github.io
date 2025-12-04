---
title: GPFS命令行手册
date: 2025-10-03T16:48:08+08:00
draft: false
tags:
- Devops
- Tutorial
- IT
- paper
- Book
- Linux
author: Ringi Lee
showToc: true
tocOpen: false
---

# GPFS命令行手册

## Introduction

# **GPFS (General Parallel File System) 操作命令手册**


**适用范围**: IBM Storage Scale (GPFS) 5.1.x - 5.2.x &#x20;

**参考文档**: [IBM Storage Scale Administration Guide](https://www.ibm.com/docs/en/STXKQY\_5.1.9/pdf/scale\_adm.pdf)



## **🔍 系统状态查看**



### **集群状态检查**

```bash
# 查看所有节点的GPFS状态
mmgetstate -a
# 参数说明：-a 显示所有节点状态

# 查看特定节点状态
mmgetstate -N node1,node2
# 参数说明：-N 指定节点列表

# 查看集群配置信息
mmlscluster
# 显示集群的基本配置信息，包括节点角色、版本等

# 查看集群详细信息
mmlscluster -v
# 参数说明：-v 详细输出模式
```



### **节点信息查看**

```bash
# 列出所有节点信息
mmlsnode -a
# 参数说明：-a 显示所有节点

# 查看特定节点详细信息
mmlsnode -N node1 -v
# 参数说明：-N 指定节点，-v 详细输出

# 查看节点角色和状态
mmlsnode -a -L
# 参数说明：-L 显示节点角色（管理器、客户端等）

# 查看GPFS版本信息
mmlsconfig releaseLevel
# 显示当前GPFS版本
```



### **系统资源监控**

```bash
# 查看系统配置参数
mmlsconfig
# 显示所有GPFS配置参数

# 查看特定配置参数
mmlsconfig pagepool
# 查看页面池配置

# 查看系统许可证信息
mmlslicense -L
# 参数说明：-L 详细显示许可证信息
```



***



## **🏗️ 集群管理**



### **集群创建和配置**

```bash
# 创建GPFS集群
mmcrcluster -C cluster_name -p primary_node -s secondary_node -r /usr/bin/ssh -R /usr/bin/scp
# 参数说明：
# -C 集群名称
# -p 主节点
# -s 备节点
# -r 远程shell命令
# -R 远程复制命令

# 添加节点到集群
mmaddnode -N node_descriptor_file
# 参数说明：-N 节点描述文件

# 删除节点
mmdelnode -N node_list
# 参数说明：-N 要删除的节点列表

# 启动GPFS集群
mmstartup -a
# 参数说明：-a 启动所有节点

# 关闭GPFS集群
mmshutdown -a
# 参数说明：-a 关闭所有节点
```



### **集群配置管理**

```bash
# 修改集群配置
mmchconfig parameter=value
# 示例：mmchconfig pagepool=1G

# 查看配置更改历史
mmlsconfig -i
# 参数说明：-i 显示配置更改历史

# 应用配置更改
mmchconfig -i
# 立即应用配置更改

# 重新加载配置
mmrefresh -f
# 参数说明：-f 强制刷新配置
```



***



## **💾 文件系统管理**



### **文件系统创建**

```bash
# 创建文件系统
mmcrfs filesystem_name device_name -F disk_descriptor_file
# 参数说明：
# filesystem_name 文件系统名称
# device_name 设备名称
# -F 磁盘描述文件

# 创建文件系统（带详细参数）
mmcrfs gpfs01 /dev/gpfs01 -F /tmp/disks.txt -A yes -Q yes -r 2 -R 2
# 参数说明：
# -A 启用自动挂载
# -Q 启用配额
# -r 数据副本数
# -R 元数据副本数
```



### **文件系统查看**

```bash
# 列出所有文件系统
mmlsfs all
# 显示所有文件系统的基本信息

# 查看特定文件系统详细信息
mmlsfs filesystem_name -v
# 参数说明：-v 详细输出模式

# 查看文件系统挂载状态
mmlsmount all
# 显示所有文件系统的挂载状态

# 查看文件系统挂载点
mmlsmount filesystem_name
# 显示特定文件系统的挂载信息
```



### **文件系统操作**

```bash
# 挂载文件系统
mmmount filesystem_name -a
# 参数说明：-a 在所有节点上挂载

# 卸载文件系统
mmumount filesystem_name -a
# 参数说明：-a 在所有节点上卸载

# 修改文件系统属性
mmchfs filesystem_name -A yes
# 参数说明：-A 启用/禁用自动挂载

# 修改文件系统块大小
mmchfs filesystem_name -B 4M
# 参数说明：-B 块大小（仅在文件系统为空时可修改）

# 修改文件系统描述
mmchfs filesystem_name -D "新的文件系统描述"
# 参数说明：-D 文件系统描述

# 修改文件系统挂载点
mmchfs filesystem_name -T /new/mount/point
# 参数说明：-T 挂载点路径

# 修改文件系统设备名
mmchfs filesystem_name -W /dev/new_device
# 参数说明：-W 新的设备名

# 启用/禁用配额
mmchfs filesystem_name -Q user,group,fileset
# 参数说明：-Q 配额类型（user、group、fileset）

# 修改副本数
mmchfs filesystem_name -r 3 -R 2
# 参数说明：-r 数据副本数，-R 元数据副本数

# 启用/禁用压缩
mmchfs filesystem_name -z yes
# 参数说明：-z 启用压缩

# 修改日志大小
mmchfs filesystem_name -l 078M
# 参数说明：-l 日志大小

# 启用/禁用加密
mmchfs filesystem_name --encryption yes
# 参数说明：--encryption 启用加密

# 删除文件系统
mmdelfs filesystem_name
# 注意：删除前需要先卸载文件系统

# 强制删除文件系统
mmdelfs filesystem_name -f
# 参数说明：-f 强制删除（忽略警告）

# 重命名文件系统
mmchfs filesystem_name -n new_filesystem_name
# 参数说明：-n 新的文件系统名称
```



### **文件系统扩展和收缩**

```bash
# 扩展文件系统
mmadddisk filesystem_name -F disk_descriptor_file
# 添加磁盘来扩展文件系统

# 收缩文件系统
mmdeldisk filesystem_name disk_name
# 删除磁盘来收缩文件系统

# 平衡文件系统
mmrestripefs filesystem_name
# 重新分布文件系统数据

# 平衡文件系统（指定存储池）
mmrestripefs filesystem_name -P storage_pool
# 参数说明：-P 指定存储池

# 重新分布单个文件
mmrestripefile filename
# 重新分布单个文件的数据

# 重新分布目录
mmrestripefile -r directory_name
# 参数说明：-r 递归处理目录
```



### **文件系统版本管理**

```bash
# 查看文件系统版本
mmlsfs filesystem_name -T | grep version
# 显示文件系统版本信息

# 升级文件系统版本
mmchfs filesystem_name -V full
# 参数说明：-V full 升级到完整版本

# 升级文件系统版本（本地访问）
mmchfs filesystem_name -V local
# 参数说明：-V local 仅升级本地访问版本

# 检查文件系统一致性
mmfsck filesystem_name
# 检查文件系统一致性

# 修复文件系统
mmfsck filesystem_name -f
# 参数说明：-f 自动修复错误

# 检查文件系统（只读）
mmfsck filesystem_name -n
# 参数说明：-n 只读检查，不修复
```



### **文件系统监控**

```bash
# 查看文件系统I/O统计
mmfsadm dump iohist filesystem_name
# 显示文件系统I/O历史

# 查看文件系统缓存统计
mmfsadm dump cache filesystem_name
# 显示缓存统计信息

# 查看文件系统锁统计
mmfsadm dump locks filesystem_name
# 显示锁统计信息

# 查看文件系统内存使用
mmfsadm dump memory filesystem_name
# 显示内存使用统计

# 查看文件系统网络统计
mmfsadm dump network filesystem_name
# 显示网络统计信息

# 查看文件系统日志
mmfsadm dump log filesystem_name
# 显示文件系统日志
```



### **文件系统维护**

```bash
# 暂停文件系统
mmfsadm suspend filesystem_name
# 暂停文件系统操作

# 恢复文件系统
mmfsadm resume filesystem_name
# 恢复文件系统操作

# 刷新文件系统缓存
mmfsadm flush filesystem_name
# 刷新文件系统缓存

# 清理文件系统
mmfsadm cleanup filesystem_name
# 清理文件系统资源

# 重新加载文件系统配置
mmfsadm reload filesystem_name
# 重新加载配置

# 强制卸载文件系统
mmfsadm force-unmount filesystem_name
# 强制卸载文件系统
```



### **文件系统恢复**

```bash
# 恢复文件系统配置
mmcommon recoverfs filesystem_name
# 恢复文件系统配置信息

# 恢复文件系统元数据
mmfsck filesystem_name --recover-metadata
# 恢复元数据

# 恢复文件系统数据
mmfsck filesystem_name --recover-data
# 恢复数据

# 从备份恢复文件系统
mmrestore filesystem_name -f backup_file
# 从备份文件恢复

# 恢复文件系统描述符
mmfsck filesystem_name --recover-descriptor
# 恢复文件系统描述符
```



***



## **🗄️ 存储和磁盘管理**



### **磁盘创建和管理**

```bash
# 创建NSD (Network Shared Disk)
mmcrnsd -F disk_descriptor_file
# 参数说明：-F 磁盘描述文件

# 创建NSD（指定服务器）
mmcrnsd -F disk_descriptor_file -v yes
# 参数说明：-v 详细输出

# 创建NSD（批量）
mmcrnsd -F disk_descriptor_file -B yes
# 参数说明：-B 批量模式

# 修改NSD属性
mmchnsd -d disk_name -N server_list
# 参数说明：-d 磁盘名称，-N 服务器列表

# 修改NSD服务器
mmchnsd -d disk_name -N primary_server:backup_server
# 指定主服务器和备份服务器

# 查看NSD信息
mmlsnsd
# 显示所有NSD信息

# 查看特定NSD信息
mmlsnsd -d disk_name
# 参数说明：-d 磁盘名称

# 查看NSD详细信息
mmlsnsd -d disk_name -v
# 参数说明：-v 详细输出

# 查看NSD使用情况
mmlsnsd -m
# 参数说明：-m 显示使用情况

# 删除NSD
mmdelnsd disk_name
# 删除指定NSD

# 删除NSD（保留数据）
mmdelnsd disk_name -p
# 参数说明：-p 保留数据，仅删除NSD标记
```



### **磁盘操作**

```bash
# 列出所有磁盘
mmlsdisk filesystem_name
# 显示文件系统中的所有磁盘

# 查看磁盘详细信息
mmlsdisk filesystem_name -v
# 参数说明：-v 详细输出模式

# 查看磁盘使用情况
mmlsdisk filesystem_name -L
# 参数说明：-L 显示使用情况

# 查看磁盘故障组
mmlsdisk filesystem_name -F
# 参数说明：-F 显示故障组信息

# 添加磁盘到文件系统
mmadddisk filesystem_name -F disk_descriptor_file
# 参数说明：-F 磁盘描述文件

# 添加磁盘（指定存储池）
mmadddisk filesystem_name -F disk_descriptor_file -P storage_pool
# 参数说明：-P 存储池名称

# 从文件系统删除磁盘
mmdeldisk filesystem_name disk_name
# 删除指定磁盘

# 删除磁盘（数据迁移）
mmdeldisk filesystem_name disk_name -r
# 参数说明：-r 重新分布数据

# 替换磁盘
mmreplacedisk filesystem_name old_disk new_disk
# 替换故障磁盘

# 修改磁盘属性
mmchdisk filesystem_name disk_name -a dataAndMetadata
# 参数说明：-a 磁盘用途（dataOnly、metadataOnly、dataAndMetadata）

# 修改磁盘状态
mmchdisk filesystem_name disk_name -s available
# 参数说明：-s 磁盘状态（available、unavailable）

# 修改磁盘故障组
mmchdisk filesystem_name disk_name -g failure_group_id
# 参数说明：-g 故障组ID
```



### **存储池管理**

```bash
# 查看存储池信息
mmlspool filesystem_name all
# 显示所有存储池

# 查看特定存储池
mmlspool filesystem_name pool_name
# 显示特定存储池信息

# 查看存储池详细信息
mmlspool filesystem_name pool_name -v
# 参数说明：-v 详细输出

# 创建存储池
mmcrpool filesystem_name pool_name -F disk_descriptor_file
# 参数说明：-F 磁盘描述文件

# 创建存储池（指定属性）
mmcrpool filesystem_name pool_name -F disk_descriptor_file -B 4M
# 参数说明：-B 块大小

# 修改存储池
mmchpool filesystem_name pool_name -d disk_list
# 参数说明：-d 磁盘列表

# 修改存储池属性
mmchpool filesystem_name pool_name -n new_pool_name
# 参数说明：-n 新的存储池名称

# 删除存储池
mmdelpool filesystem_name pool_name
# 删除存储池

# 删除存储池（数据迁移）
mmdelpool filesystem_name pool_name -r
# 参数说明：-r 重新分布数据

# 向存储池添加磁盘
mmchpool filesystem_name pool_name -a disk_list
# 参数说明：-a 添加磁盘列表

# 从存储池删除磁盘
mmchpool filesystem_name pool_name -d disk_list
# 参数说明：-d 删除磁盘列表
```



### **空间管理**

```bash
# 查看文件系统空间使用情况
mmdf filesystem_name
# 显示文件系统的空间使用统计

# 查看详细空间使用情况
mmdf filesystem_name -v
# 参数说明：-v 详细输出模式

# 查看存储池空间使用
mmdf filesystem_name -P pool_name
# 参数说明：-P 指定存储池

# 查看所有文件系统空间使用
mmdf all
# 显示所有文件系统空间使用

# 查看inode使用情况
mmdf filesystem_name -i
# 参数说明：-i 显示inode使用情况

# 查看磁盘空间分布
mmdf filesystem_name -d
# 参数说明：-d 显示磁盘级别的空间分布

# 查看空间使用历史
mmdf filesystem_name -h
# 参数说明：-h 显示历史统计

# 清理空间
mmfsadm cleanup filesystem_name
# 清理文件系统空间
```



### **磁盘故障处理**

```bash
# 查看磁盘故障
mmlsdisk filesystem_name | grep -i fail
# 查找故障磁盘

# 标记磁盘为故障
mmchdisk filesystem_name disk_name -s failed
# 参数说明：-s failed 标记为故障

# 重新激活磁盘
mmchdisk filesystem_name disk_name -s available
# 重新激活磁盘

# 强制删除故障磁盘
mmdeldisk filesystem_name disk_name -f
# 参数说明：-f 强制删除

# 修复磁盘
mmfsck filesystem_name -d disk_name
# 修复特定磁盘

# 重建磁盘数据
mmrestripefs filesystem_name -d disk_name
# 重建磁盘上的数据
```



### **磁盘性能监控**

```bash
# 查看磁盘I/O统计
mmfsadm dump diskstats filesystem_name
# 显示磁盘I/O统计

# 查看磁盘性能
mmfsadm dump diskperf filesystem_name
# 显示磁盘性能统计

# 查看磁盘队列
mmfsadm dump diskqueue filesystem_name
# 显示磁盘队列统计

# 监控磁盘活动
mmfsadm dump diskactivity filesystem_name
# 显示磁盘活动统计
```



***



## **📊 配额管理**



### **配额启用和配置**

```bash
# 启用用户配额
mmchfs filesystem_name -Q user
# 参数说明：-Q 启用配额类型

# 启用组配额
mmchfs filesystem_name -Q group
# 启用组配额管理

# 启用文件集配额
mmchfs filesystem_name -Q fileset
# 启用文件集配额管理

# 启用所有类型配额
mmchfs filesystem_name -Q user,group,fileset
# 同时启用多种配额类型

# 禁用配额
mmchfs filesystem_name -Q none
# 禁用所有配额

# 检查配额
mmcheckquota filesystem_name
# 检查并修复配额不一致

# 检查用户配额
mmcheckquota -u filesystem_name
# 参数说明：-u 仅检查用户配额

# 检查组配额
mmcheckquota -g filesystem_name
# 参数说明：-g 仅检查组配额

# 检查文件集配额
mmcheckquota -j filesystem_name
# 参数说明：-j 仅检查文件集配额

# 强制重建配额
mmcheckquota filesystem_name -f
# 参数说明：-f 强制重建配额数据库
```



### **配额查看和报告**

```bash
# 查看用户配额
mmrepquota -u filesystem_name
# 参数说明：-u 用户配额

# 查看组配额
mmrepquota -g filesystem_name
# 参数说明：-g 组配额

# 查看文件集配额
mmrepquota -j filesystem_name
# 参数说明：-j 文件集配额

# 查看特定用户配额
mmrepquota -u filesystem_name username
# 查看指定用户的配额使用情况

# 查看特定组配额
mmrepquota -g filesystem_name groupname
# 查看指定组的配额使用情况

# 查看配额详细信息
mmrepquota -u filesystem_name -v
# 参数说明：-v 详细输出

# 查看配额（机器可读格式）
mmrepquota -u filesystem_name -Y
# 参数说明：-Y 机器可读格式

# 查看配额使用统计
mmrepquota -u filesystem_name -s
# 参数说明：-s 显示统计信息

# 查看超出配额的用户
mmrepquota -u filesystem_name -q
# 参数说明：-q 仅显示超出配额的用户

# 查看配额历史
mmrepquota -u filesystem_name -h
# 参数说明：-h 显示历史配额使用

# 导出配额报告
mmrepquota -u filesystem_name > quota_report.txt
# 导出配额报告到文件
```



### **配额设置和修改**

```bash
# 设置用户配额（交互式）
mmedquota -u username filesystem_name
# 交互式设置用户配额

# 设置组配额（交互式）
mmedquota -g groupname filesystem_name
# 交互式设置组配额

# 设置文件集配额（交互式）
mmedquota -j filesetname filesystem_name
# 交互式设置文件集配额

# 批量设置用户配额
mmsetquota -u username -B 10G -Q 07G filesystem_name
# 参数说明：
# -B 块软限制
# -Q 块硬限制

# 设置用户配额（包含文件数）
mmsetquota -u username -B 10G -Q 07G -k 100000 -K 070000 filesystem_name
# 参数说明：
# -k 文件数软限制
# -K 文件数硬限制

# 设置组配额
mmsetquota -g groupname -B 100G -Q 070G filesystem_name
# 设置组的块配额

# 设置文件集配额
mmsetquota -j filesetname -B 50G -Q 60G filesystem_name
# 设置文件集配额

# 设置配额宽限期
mmsetquota -u username -T 7d filesystem_name
# 参数说明：-T 宽限期（天数）

# 清除用户配额
mmsetquota -u username -B 0 -Q 0 filesystem_name
# 设置为0清除配额限制

# 复制配额设置
mmsetquota -u user1 -U user2 filesystem_name
# 参数说明：-U 从user2复制配额设置到user1

# 批量设置配额
mmsetquota -f quota_file filesystem_name
# 参数说明：-f 从文件批量设置配额
```



### **配额监控和报警**

```bash
# 监控配额使用
mmrepquota -u filesystem_name -w
# 参数说明：-w 监控模式

# 查看配额警告
mmrepquota -u filesystem_name -W
# 参数说明：-W 显示警告信息

# 查看配额违规
mmrepquota -u filesystem_name -V
# 参数说明：-V 显示违规信息

# 配额使用趋势
mmrepquota -u filesystem_name -t
# 参数说明：-t 显示趋势信息

# 配额使用排序
mmrepquota -u filesystem_name -S size
# 参数说明：-S 按大小排序

# 配额使用排序（按文件数）
mmrepquota -u filesystem_name -S files
# 按文件数排序

# 生成配额报告
mmrepquota -u filesystem_name -r > quota_report.html
# 参数说明：-r 生成HTML报告
```



### **配额管理工具**

```bash
# 配额数据库维护
mmquotadb filesystem_name -c
# 参数说明：-c 压缩配额数据库

# 配额数据库重建
mmquotadb filesystem_name -r
# 参数说明：-r 重建配额数据库

# 配额数据库验证
mmquotadb filesystem_name -v
# 参数说明：-v 验证配额数据库

# 配额数据库备份
mmquotadb filesystem_name -b backup_file
# 参数说明：-b 备份配额数据库

# 配额数据库恢复
mmquotadb filesystem_name -R backup_file
# 参数说明：-R 从备份恢复

# 配额统计
mmquotastat filesystem_name
# 显示配额统计信息

# 配额历史清理
mmquotadb filesystem_name -p 30
# 参数说明：-p 保留30天的历史数据
```



### **高级配额管理**

```bash
# 设置默认配额
mmsetdefaultquota -u -B 1G -Q 2G filesystem_name
# 设置新用户的默认配额

# 设置配额策略
mmsetquotapolicy filesystem_name -f policy_file
# 参数说明：-f 配额策略文件

# 配额继承设置
mmsetquota -u username -I parent_user filesystem_name
# 参数说明：-I 继承父用户配额

# 临时配额设置
mmsetquota -u username -B 5G -Q 6G -E 7d filesystem_name
# 参数说明：-E 临时配额期限

# 配额组管理
mmcrquotagroup group_name filesystem_name
# 创建配额组

# 配额组成员管理
mmchquotagroup group_name -a user1,user2 filesystem_name
# 参数说明：-a 添加成员

# 配额通知设置
mmsetquotanotify -u username -m email@domain.com filesystem_name
# 参数说明：-m 通知邮箱

# 配额自动化
mmsetquotaauto filesystem_name -e yes
# 参数说明：-e 启用自动配额管理
```



### **配额故障排除**

```bash
# 配额不一致检查
mmcheckquota filesystem_name -n
# 参数说明：-n 仅检查不修复

# 配额修复
mmcheckquota filesystem_name -f -v
# 参数说明：-f 强制修复，-v 详细输出

# 配额重置
mmresetquota -u username filesystem_name
# 重置用户配额使用计数

# 配额重新计算
mmrecalcquota filesystem_name
# 重新计算配额使用量

# 配额日志查看
mmquotalog filesystem_name
# 查看配额操作日志

# 配额错误日志
mmquotalog filesystem_name -e
# 参数说明：-e 仅显示错误日志
```



***



## **📈 性能监控**



### **性能监控配置**

```bash
# 查看性能监控配置
mmperfmon config show
# 显示性能监控配置

# 启动性能监控收集
mmperfmon config update period=60
# 设置监控周期为60秒

# 设置性能监控参数
mmperfmon config update colCandidates=node1,node2
# 设置候选收集节点

# 设置监控数据保留期
mmperfmon config update retention=30
# 设置数据保留30天

# 启用性能监控
mmperfmon config update enabled=yes
# 启用性能监控

# 禁用性能监控
mmperfmon config update enabled=no
# 禁用性能监控

# 设置监控指标
mmperfmon config update metrics=cpu,memory,io,network
# 设置要监控的指标

# 配置监控阈值
mmperfmon config update thresholds=cpu:80,memory:90
# 设置监控阈值
```



### **性能数据查询**

```bash
# 查看当前性能数据
mmperfmon query show
# 显示当前性能数据

# 查看I/O统计
mmperfmon query io_s
# 显示I/O统计信息

# 查看CPU使用率
mmperfmon query cpu_s
# 显示CPU使用率

# 查看内存使用
mmperfmon query memory_s
# 显示内存使用统计

# 查看网络统计
mmperfmon query network_s
# 显示网络统计信息

# 查看磁盘统计
mmperfmon query disk_s
# 显示磁盘统计信息

# 查看文件系统统计
mmperfmon query filesystem_s
# 显示文件系统统计

# 查看节点统计
mmperfmon query node_s
# 显示节点统计信息

# 查看历史数据
mmperfmon query show -s 2025-01-01 -e 2025-01-31
# 参数说明：-s 开始时间，-e 结束时间

# 查看特定节点性能
mmperfmon query show -n node1,node2
# 参数说明：-n 指定节点

# 查看特定文件系统性能
mmperfmon query show -f filesystem_name
# 参数说明：-f 指定文件系统
```



### **系统性能监控**

```bash
# 查看文件系统性能
mmfsadm dump iohist
# 显示I/O历史统计

# 查看详细I/O统计
mmfsadm dump iohist -v
# 参数说明：-v 详细输出

# 查看网络性能
mmfsadm dump tcpstats
# 显示TCP统计信息

# 查看网络连接
mmfsadm dump connections
# 显示网络连接统计

# 查看内存使用
mmfsadm dump memstats
# 显示内存使用统计

# 查看缓存统计
mmfsadm dump cache
# 显示缓存统计信息

# 查看锁统计
mmfsadm dump lockstats
# 显示锁统计信息

# 查看线程统计
mmfsadm dump threadstats
# 显示线程统计信息

# 查看队列统计
mmfsadm dump queuestats
# 显示队列统计信息

# 查看等待统计
mmfsadm dump waitstats
# 显示等待统计信息
```



### **健康检查和监控**

```bash
# 检查节点健康状态
mmhealth node show
# 显示节点健康状态

# 检查特定节点健康
mmhealth node show -n node1
# 参数说明：-n 指定节点

# 检查集群健康状态
mmhealth cluster show
# 显示集群健康状态

# 查看健康事件
mmhealth event show
# 显示健康事件历史

# 查看健康事件（特定类型）
mmhealth event show -t error
# 参数说明：-t 事件类型

# 查看健康事件（特定时间）
mmhealth event show -s 2025-01-01
# 参数说明：-s 开始时间

# 查看健康阈值
mmhealth threshold show
# 显示健康检查阈值

# 设置健康阈值
mmhealth threshold set -t cpu_usage -v 80
# 参数说明：-t 阈值类型，-v 阈值

# 启用健康监控
mmhealth monitor enable
# 启用健康监控

# 禁用健康监控
mmhealth monitor disable
# 禁用健康监控

# 健康检查报告
mmhealth report generate
# 生成健康检查报告
```



### **实时监控工具**

```bash
# 实时监控I/O
mmfsadm dump iohist -r
# 参数说明：-r 实时模式

# 实时监控网络
mmfsadm dump tcpstats -r
# 实时监控网络统计

# 实时监控内存
mmfsadm dump memstats -r
# 实时监控内存使用

# 实时监控锁
mmfsadm dump lockstats -r
# 实时监控锁统计

# 监控文件系统活动
mmfsadm dump activity
# 显示文件系统活动

# 监控客户端活动
mmfsadm dump clientstats
# 显示客户端活动统计

# 监控服务器活动
mmfsadm dump serverstats
# 显示服务器活动统计
```



### **性能分析工具**

```bash
# 性能分析
mmperf analyze filesystem_name
# 分析文件系统性能

# I/O性能分析
mmperf analyze -t io filesystem_name
# 参数说明：-t 分析类型

# 网络性能分析
mmperf analyze -t network filesystem_name
# 分析网络性能

# 内存性能分析
mmperf analyze -t memory filesystem_name
# 分析内存性能

# 生成性能报告
mmperf report filesystem_name
# 生成性能报告

# 性能趋势分析
mmperf trend filesystem_name
# 分析性能趋势

# 性能瓶颈分析
mmperf bottleneck filesystem_name
# 分析性能瓶颈

# 性能优化建议
mmperf optimize filesystem_name
# 提供性能优化建议
```



### **监控数据管理**

```bash
# 清理监控数据
mmperfmon cleanup -d 30
# 参数说明：-d 清理30天前的数据

# 导出监控数据
mmperfmon export -f csv -o output.csv
# 参数说明：-f 格式，-o 输出文件

# 导入监控数据
mmperfmon import -f input.csv
# 参数说明：-f 输入文件

# 监控数据备份
mmperfmon backup -o backup.tar
# 参数说明：-o 备份文件

# 监控数据恢复
mmperfmon restore -f backup.tar
# 参数说明：-f 备份文件

# 监控数据压缩
mmperfmon compress
# 压缩监控数据

# 监控数据统计
mmperfmon stats
# 显示监控数据统计
```



### **告警和通知**

```bash
# 配置告警
mmhealth alert config -t email -r admin@domain.com
# 参数说明：-t 告警类型，-r 接收者

# 启用告警
mmhealth alert enable
# 启用告警功能

# 禁用告警
mmhealth alert disable
# 禁用告警功能

# 查看告警历史
mmhealth alert history
# 显示告警历史

# 清除告警
mmhealth alert clear
# 清除当前告警

# 测试告警
mmhealth alert test
# 测试告警功能

# 告警规则管理
mmhealth alert rule add -n "CPU High" -c "cpu_usage > 80"
# 参数说明：-n 规则名称，-c 条件

# 删除告警规则
mmhealth alert rule delete -n "CPU High"
# 参数说明：-n 规则名称
```



### **性能调优**

```bash
# 性能调优分析
mmtune analyze filesystem_name
# 分析调优机会

# 应用调优建议
mmtune apply filesystem_name
# 应用调优建议

# 调优配置
mmtune config show
# 显示调优配置

# 设置调优参数
mmtune config set -p pagepool -v 4G
# 参数说明：-p 参数名，-v 参数值

# 调优测试
mmtune test filesystem_name
# 测试调优效果

# 调优报告
mmtune report filesystem_name
# 生成调优报告

# 调优回滚
mmtune rollback filesystem_name
# 回滚调优更改
```



***



## **🔐 安全和认证**



### **认证配置**

```bash
# 生成认证密钥
mmauth genkey new
# 生成新的认证密钥

# 生成认证密钥（指定长度）
mmauth genkey new -l 2048
# 参数说明：-l 密钥长度

# 显示认证状态
mmauth show
# 显示当前认证配置

# 显示认证详细信息
mmauth show -v
# 参数说明：-v 详细输出

# 更新认证密钥
mmauth update /path/to/keyfile
# 更新认证密钥文件

# 从文件更新认证密钥
mmauth update -f keyfile
# 参数说明：-f 密钥文件

# 提交认证更改
mmauth commit
# 提交认证配置更改

# 回滚认证更改
mmauth rollback
# 回滚认证更改

# 删除认证密钥
mmauth delete
# 删除认证密钥

# 测试认证
mmauth test -n node1
# 参数说明：-n 测试节点

# 认证密钥备份
mmauth backup -o auth_backup.key
# 参数说明：-o 备份文件

# 认证密钥恢复
mmauth restore -f auth_backup.key
# 参数说明：-f 备份文件
```



### **SSL/TLS配置**

```bash
# 启用SSL
mmauth ssl enable
# 启用SSL加密

# 禁用SSL
mmauth ssl disable
# 禁用SSL加密

# 配置SSL证书
mmauth ssl cert -f certificate.pem
# 参数说明：-f 证书文件

# 配置SSL私钥
mmauth ssl key -f private_key.pem
# 参数说明：-f 私钥文件

# 配置SSL CA证书
mmauth ssl ca -f ca_cert.pem
# 参数说明：-f CA证书文件

# 生成SSL证书
mmauth ssl generate -cn cluster.domain.com
# 参数说明：-cn 通用名称

# 验证SSL证书
mmauth ssl verify
# 验证SSL证书

# 查看SSL状态
mmauth ssl status
# 显示SSL状态

# 更新SSL证书
mmauth ssl update -f new_cert.pem
# 参数说明：-f 新证书文件

# SSL证书续期
mmauth ssl renew
# 续期SSL证书
```



### **访问控制**

```bash
# 查看ACL
mmgetacl filename
# 显示文件的访问控制列表

# 设置ACL
mmputacl -i acl_file filename
# 参数说明：-i 从文件读取ACL规则

# 设置ACL（直接指定）
mmputacl -a "user:john:rwx" filename
# 参数说明：-a 添加ACL条目

# 删除ACL
mmdelacl filename
# 删除文件的ACL

# 删除特定ACL条目
mmdelacl -a "user:john" filename
# 参数说明：-a 删除特定条目

# 修改ACL
mmchacl -m "user:john:r--" filename
# 参数说明：-m 修改ACL条目

# 递归设置ACL
mmputacl -R -i acl_file directory
# 参数说明：-R 递归设置

# 默认ACL设置
mmputacl -d -i default_acl_file directory
# 参数说明：-d 设置默认ACL

# ACL继承设置
mmputacl -I -i acl_file directory
# 参数说明：-I 设置继承ACL

# 查看ACL权限
mmgetacl -n filename
# 参数说明：-n 数字格式显示

# 备份ACL
mmgetacl -R directory > acl_backup.txt
# 备份目录的ACL

# 恢复ACL
mmputacl -R -i acl_backup.txt directory
# 恢复ACL设置
```



### **用户和组管理**

```bash
# 查看用户信息
mmgetuser username
# 显示用户信息

# 查看组信息
mmgetgroup groupname
# 显示组信息

# 查看用户权限
mmgetperm username filesystem_name
# 显示用户在文件系统上的权限

# 设置用户权限
mmsetperm username filesystem_name -p read,write
# 参数说明：-p 权限列表

# 添加用户到组
mmadduser username groupname
# 将用户添加到组

# 从组删除用户
mmdeluser username groupname
# 从组删除用户

# 创建用户组
mmcrgroup groupname
# 创建用户组

# 删除用户组
mmdelgroup groupname
# 删除用户组

# 修改用户属性
mmchuser username -s /bin/bash
# 参数说明：-s 设置shell

# 修改组属性
mmchgroup groupname -d "Group description"
# 参数说明：-d 组描述
```



### **加密管理**

```bash
# 启用文件系统加密
mmchfs filesystem_name -z yes
# 参数说明：-z 启用加密

# 禁用文件系统加密
mmchfs filesystem_name -z no
# 禁用加密

# 查看加密状态
mmlsfs filesystem_name -z
# 显示加密状态

# 管理加密密钥
mmkeyserv start
# 启动密钥服务器

# 停止密钥服务器
mmkeyserv stop
# 停止密钥服务器

# 查看密钥服务器状态
mmkeyserv status
# 显示密钥服务器状态

# 生成加密密钥
mmkeyserv genkey -k keyname
# 参数说明：-k 密钥名称

# 删除加密密钥
mmkeyserv delkey -k keyname
# 参数说明：-k 密钥名称

# 列出加密密钥
mmkeyserv listkeys
# 列出所有密钥

# 备份加密密钥
mmkeyserv backup -o keys_backup.tar
# 参数说明：-o 备份文件

# 恢复加密密钥
mmkeyserv restore -f keys_backup.tar
# 参数说明：-f 备份文件

# 密钥轮换
mmkeyserv rotate -k keyname
# 参数说明：-k 密钥名称
```



### **审计和日志**

```bash
# 启用审计
mmaudit enable
# 启用审计功能

# 禁用审计
mmaudit disable
# 禁用审计功能

# 查看审计状态
mmaudit status
# 显示审计状态

# 查看审计日志
mmaudit log
# 显示审计日志

# 查看审计日志（特定用户）
mmaudit log -u username
# 参数说明：-u 用户名

# 查看审计日志（特定操作）
mmaudit log -o create,delete
# 参数说明：-o 操作类型

# 查看审计日志（特定时间）
mmaudit log -s 2025-01-01 -e 2025-01-31
# 参数说明：-s 开始时间，-e 结束时间

# 配置审计规则
mmaudit rule add -n "File Access" -f "/secure/*" -o read,write
# 参数说明：-n 规则名称，-f 文件路径，-o 操作

# 删除审计规则
mmaudit rule delete -n "File Access"
# 参数说明：-n 规则名称

# 导出审计日志
mmaudit export -f csv -o audit.csv
# 参数说明：-f 格式，-o 输出文件

# 清理审计日志
mmaudit cleanup -d 90
# 参数说明：-d 保留天数
```



### **防火墙和网络安全**

```bash
# 配置防火墙规则
mmfirewall add -s 192.168.1.0/24 -p 1191
# 参数说明：-s 源地址，-p 端口

# 删除防火墙规则
mmfirewall delete -s 192.168.1.0/24
# 参数说明：-s 源地址

# 查看防火墙规则
mmfirewall list
# 显示防火墙规则

# 启用防火墙
mmfirewall enable
# 启用防火墙

# 禁用防火墙
mmfirewall disable
# 禁用防火墙

# 配置网络安全
mmnetwork security enable
# 启用网络安全

# 配置IP白名单
mmnetwork whitelist add -i 192.168.1.100
# 参数说明：-i IP地址

# 配置IP黑名单
mmnetwork blacklist add -i 192.168.1.200
# 参数说明：-i IP地址

# 查看网络连接
mmnetwork connections
# 显示网络连接

# 网络安全扫描
mmnetwork scan
# 扫描网络安全问题
```



### **安全策略管理**

```bash
# 创建安全策略
mmsecpolicy create -n "Security Policy" -f policy.xml
# 参数说明：-n 策略名称，-f 策略文件

# 应用安全策略
mmsecpolicy apply -n "Security Policy"
# 参数说明：-n 策略名称

# 删除安全策略
mmsecpolicy delete -n "Security Policy"
# 参数说明：-n 策略名称

# 查看安全策略
mmsecpolicy list
# 显示安全策略

# 验证安全策略
mmsecpolicy validate -f policy.xml
# 参数说明：-f 策略文件

# 安全策略报告
mmsecpolicy report
# 生成安全策略报告

# 安全基线检查
mmsecbaseline check
# 检查安全基线

# 安全漏洞扫描
mmsecscan
# 扫描安全漏洞

# 安全配置检查
mmseccheck
# 检查安全配置
```



### **证书管理**

```bash
# 生成证书请求
mmcert request -cn cluster.domain.com -o cert.csr
# 参数说明：-cn 通用名称，-o 输出文件

# 安装证书
mmcert install -f certificate.pem
# 参数说明：-f 证书文件

# 查看证书信息
mmcert info -f certificate.pem
# 参数说明：-f 证书文件

# 验证证书
mmcert verify -f certificate.pem
# 参数说明：-f 证书文件

# 更新证书
mmcert update -f new_certificate.pem
# 参数说明：-f 新证书文件

# 删除证书
mmcert delete -f certificate.pem
# 参数说明：-f 证书文件

# 证书续期
mmcert renew -f certificate.pem
# 参数说明：-f 证书文件

# 导出证书
mmcert export -f certificate.pem -o exported_cert.pem
# 参数说明：-f 源证书，-o 输出文件

# 证书备份
mmcert backup -o certs_backup.tar
# 参数说明：-o 备份文件

# 证书恢复
mmcert restore -f certs_backup.tar
# 参数说明：-f 备份文件
```



***



## **🌐 网络共享服务**



### **NFS服务管理**

```bash
# 启动NFS服务
mmces service start NFS
# 启动NFS服务

# 停止NFS服务
mmces service stop NFS
# 停止NFS服务

# 重启NFS服务
mmces service restart NFS
# 重启NFS服务

# 查看NFS服务状态
mmces service list
# 显示所有服务状态

# 查看NFS服务详细状态
mmces service show NFS
# 显示NFS服务详细信息

# 启用NFS服务自动启动
mmces service enable NFS
# 启用服务自动启动

# 禁用NFS服务自动启动
mmces service disable NFS
# 禁用服务自动启动

# 配置NFS服务
mmces service config NFS -p parameter=value
# 参数说明：-p 配置参数

# 查看NFS配置
mmces service config NFS show
# 显示NFS配置

# 重新加载NFS配置
mmces service reload NFS
# 重新加载配置
```



### **NFS导出管理**

```bash
# 创建NFS导出
mmnfs export add /gpfs/share -c 192.168.1.0/24
# 参数说明：-c 指定客户端网络

# 创建NFS导出（详细选项）
mmnfs export add /gpfs/share -c 192.168.1.0/24 -o rw,sync,no_root_squash
# 参数说明：-o 导出选项

# 创建NFS导出（指定名称）
mmnfs export add /gpfs/share -n share_name -c 192.168.1.0/24
# 参数说明：-n 导出名称

# 修改NFS导出
mmnfs export modify share_name -c 192.168.1.0/24,10.0.0.0/8
# 修改客户端访问列表

# 删除NFS导出
mmnfs export delete share_name
# 删除指定导出

# 查看NFS导出
mmnfs export list
# 显示所有NFS导出

# 查看特定NFS导出
mmnfs export show share_name
# 显示特定导出详情

# 导出NFS配置
mmnfs export export -f nfs_exports.conf
# 参数说明：-f 导出文件

# 导入NFS配置
mmnfs export import -f nfs_exports.conf
# 参数说明：-f 导入文件

# 刷新NFS导出
mmnfs export refresh
# 刷新导出列表

# 测试NFS导出
mmnfs export test share_name
# 测试导出可用性
```



### **SMB服务管理**

```bash
# 启动SMB服务
mmces service start SMB
# 启动SMB服务

# 停止SMB服务
mmces service stop SMB
# 停止SMB服务

# 重启SMB服务
mmces service restart SMB
# 重启SMB服务

# 查看SMB服务状态
mmces service show SMB
# 显示SMB服务状态

# 启用SMB服务
mmces service enable SMB
# 启用SMB服务

# 禁用SMB服务
mmces service disable SMB
# 禁用SMB服务

# 配置SMB服务
mmces service config SMB -p workgroup=WORKGROUP
# 参数说明：-p 配置参数

# 查看SMB配置
mmces service config SMB show
# 显示SMB配置

# 重新加载SMB配置
mmces service reload SMB
# 重新加载配置
```



### **SMB共享管理**

```bash
# 创建SMB共享
mmsmb export add share_name /gpfs/share
# 创建SMB共享

# 创建SMB共享（详细选项）
mmsmb export add share_name /gpfs/share -o "browseable=yes,writeable=yes"
# 参数说明：-o 共享选项

# 创建SMB共享（指定用户）
mmsmb export add share_name /gpfs/share -u user1,user2
# 参数说明：-u 用户列表

# 修改SMB共享
mmsmb export modify share_name -o "read only=no"
# 修改共享选项

# 删除SMB共享
mmsmb export delete share_name
# 删除SMB共享

# 查看SMB共享
mmsmb export list
# 显示所有SMB共享

# 查看特定SMB共享
mmsmb export show share_name
# 显示特定共享详情

# 设置SMB共享权限
mmsmb export permission set share_name -u user1 -p read,write
# 参数说明：-u 用户，-p 权限

# 查看SMB共享权限
mmsmb export permission show share_name
# 显示共享权限

# 导出SMB配置
mmsmb export export -f smb_shares.conf
# 参数说明：-f 导出文件

# 导入SMB配置
mmsmb export import -f smb_shares.conf
# 参数说明：-f 导入文件
```



### **SMB用户管理**

```bash
# 添加SMB用户
mmsmb user add username
# 添加SMB用户

# 添加SMB用户（指定密码）
mmsmb user add username -p password
# 参数说明：-p 密码

# 删除SMB用户
mmsmb user delete username
# 删除SMB用户

# 修改SMB用户密码
mmsmb user passwd username
# 修改用户密码

# 启用SMB用户
mmsmb user enable username
# 启用用户

# 禁用SMB用户
mmsmb user disable username
# 禁用用户

# 查看SMB用户
mmsmb user list
# 显示所有SMB用户

# 查看特定SMB用户
mmsmb user show username
# 显示用户详情

# 设置SMB用户组
mmsmb user group username groupname
# 设置用户组

# 查看SMB用户组
mmsmb group list
# 显示用户组

# 创建SMB用户组
mmsmb group add groupname
# 创建用户组

# 删除SMB用户组
mmsmb group delete groupname
# 删除用户组
```



### **协议节点管理**

```bash
# 查看协议节点
mmces node list
# 显示所有协议节点

# 查看协议节点详情
mmces node show node_name
# 显示节点详情

# 添加协议节点
mmces node add node_name
# 添加协议节点

# 删除协议节点
mmces node delete node_name
# 删除协议节点

# 启用协议节点
mmces node enable node_name
# 启用协议节点

# 禁用协议节点
mmces node disable node_name
# 禁用协议节点

# 配置协议节点
mmces node config node_name -p parameter=value
# 参数说明：-p 配置参数

# 查看协议节点配置
mmces node config node_name show
# 显示节点配置

# 协议节点故障转移
mmces node failover node_name
# 故障转移

# 协议节点故障恢复
mmces node failback node_name
# 故障恢复

# 协议节点状态监控
mmces node monitor node_name
# 监控节点状态
```



### **协议服务配置**

```bash
# 配置协议服务IP
mmces address add -i 192.168.1.100 -n node_name
# 参数说明：-i IP地址，-n 节点名称

# 删除协议服务IP
mmces address delete -i 192.168.1.100
# 参数说明：-i IP地址

# 查看协议服务IP
mmces address list
# 显示所有服务IP

# 移动协议服务IP
mmces address move -i 192.168.1.100 -n target_node
# 参数说明：-i IP地址，-n 目标节点

# 配置协议服务网络
mmces network config -i interface_name -n node_name
# 参数说明：-i 网络接口，-n 节点名称

# 查看协议服务网络
mmces network show
# 显示网络配置

# 配置协议服务负载均衡
mmces loadbalance config -m round_robin
# 参数说明：-m 负载均衡模式

# 查看协议服务负载均衡
mmces loadbalance show
# 显示负载均衡配置
```



### **协议服务监控**

```bash
# 监控协议服务
mmces monitor start
# 启动监控

# 停止协议服务监控
mmces monitor stop
# 停止监控

# 查看协议服务监控
mmces monitor show
# 显示监控信息

# 协议服务性能监控
mmces performance monitor
# 性能监控

# 协议服务日志监控
mmces log monitor
# 日志监控

# 协议服务告警监控
mmces alert monitor
# 告警监控

# 协议服务健康检查
mmces health check
# 健康检查

# 协议服务故障检测
mmces failure detect
# 故障检测
```



### **高级协议配置**

```bash
# 配置协议服务集群
mmces cluster config -n cluster_name
# 参数说明：-n 集群名称

# 配置协议服务高可用
mmces ha config -m active_passive
# 参数说明：-m 高可用模式

# 配置协议服务复制
mmces replication config -t sync
# 参数说明：-t 复制类型

# 配置协议服务缓存
mmces cache config -s 1G
# 参数说明：-s 缓存大小

# 配置协议服务认证
mmces auth config -t kerberos
# 参数说明：-t 认证类型

# 配置协议服务加密
mmces encryption config -e yes
# 参数说明：-e 启用加密

# 配置协议服务压缩
mmces compression config -c yes
# 参数说明：-c 启用压缩

# 配置协议服务限流
mmces throttle config -r 100MB/s
# 参数说明：-r 限流速率
```



### **协议服务故障排除**

```bash
# 协议服务诊断
mmces diagnose
# 诊断协议服务

# 协议服务日志查看
mmces log show
# 显示日志

# 协议服务错误日志
mmces log error
# 显示错误日志

# 协议服务调试
mmces debug enable
# 启用调试模式

# 协议服务测试
mmces test connectivity
# 测试连通性

# 协议服务重置
mmces reset
# 重置协议服务

# 协议服务修复
mmces repair
# 修复协议服务

# 协议服务清理
mmces cleanup
# 清理协议服务
```



### **协议服务备份和恢复**

```bash
# 备份协议服务配置
mmces backup config -o ces_config.tar
# 参数说明：-o 备份文件

# 恢复协议服务配置
mmces restore config -f ces_config.tar
# 参数说明：-f 备份文件

# 导出协议服务配置
mmces export config -f ces_config.xml
# 参数说明：-f 导出文件

# 导入协议服务配置
mmces import config -f ces_config.xml
# 参数说明：-f 导入文件

# 协议服务配置同步
mmces sync config
# 同步配置

# 协议服务配置验证
mmces validate config
# 验证配置

# 协议服务配置回滚
mmces rollback config
# 回滚配置
```



***



## **🔧 故障排除**



### **日志查看和分析**

```bash
# 查看GPFS日志
mmfsadm dump log
# 显示GPFS日志

# 查看GPFS日志（详细）
mmfsadm dump log -v
# 参数说明：-v 详细输出

# 查看GPFS日志（特定时间）
mmfsadm dump log -s 2025-01-01 -e 2025-01-31
# 参数说明：-s 开始时间，-e 结束时间

# 查看GPFS日志（特定级别）
mmfsadm dump log -l error
# 参数说明：-l 日志级别

# 查看系统消息
tail -f /var/log/messages | grep mmfs
# 实时查看GPFS相关消息

# 查看GPFS错误日志
mmfsadm dump errorlog
# 显示错误日志

# 查看GPFS警告日志
mmfsadm dump warninglog
# 显示警告日志

# 查看GPFS调试日志
mmfsadm dump debuglog
# 显示调试日志

# 查看GPFS事件日志
mmfsadm dump eventlog
# 显示事件日志

# 设置日志级别
mmchconfig verbosity=1
# 设置日志详细级别

# 设置日志大小
mmchconfig maxLogSize=100M
# 设置日志文件最大大小

# 清理日志
mmfsadm cleanup log
# 清理日志文件

# 导出日志
mmfsadm export log -o gpfs_log.tar
# 参数说明：-o 输出文件

# 分析日志
mmfsadm analyze log
# 分析日志内容

# 日志统计
mmfsadm stats log
# 显示日志统计信息
```



### **诊断工具**

```bash
# 运行文件系统检查
mmfsck filesystem_name
# 检查文件系统一致性

# 运行文件系统检查（只读）
mmfsck filesystem_name -n
# 参数说明：-n 只读检查

# 运行文件系统检查（自动修复）
mmfsck filesystem_name -y
# 参数说明：-y 自动修复

# 运行文件系统检查（详细）
mmfsck filesystem_name -v
# 参数说明：-v 详细输出

# 诊断网络连接
mmdiag --network
# 诊断网络连接问题

# 诊断网络连接（详细）
mmdiag --network -v
# 参数说明：-v 详细输出

# 诊断磁盘问题
mmdiag --disk
# 诊断磁盘问题

# 诊断磁盘问题（特定磁盘）
mmdiag --disk -d disk_name
# 参数说明：-d 磁盘名称

# 诊断内存问题
mmdiag --memory
# 诊断内存问题

# 诊断性能问题
mmdiag --performance
# 诊断性能问题

# 诊断配置问题
mmdiag --config
# 诊断配置问题

# 诊断集群问题
mmdiag --cluster
# 诊断集群问题

# 诊断服务问题
mmdiag --service
# 诊断服务问题

# 全面诊断
mmdiag --all
# 运行所有诊断检查

# 收集诊断信息
mmcollectdebuginfo
# 收集系统调试信息

# 收集诊断信息（详细）
mmcollectdebuginfo -v
# 参数说明：-v 详细信息

# 收集诊断信息（指定输出）
mmcollectdebuginfo -o debug_info.tar
# 参数说明：-o 输出文件

# 生成诊断报告
mmdiag report
# 生成诊断报告

# 分析诊断结果
mmdiag analyze
# 分析诊断结果
```



### **性能故障排除**

```bash
# 性能问题诊断
mmperf diagnose
# 诊断性能问题

# I/O性能诊断
mmperf diagnose -t io
# 参数说明：-t 诊断类型

# 网络性能诊断
mmperf diagnose -t network
# 诊断网络性能问题

# 内存性能诊断
mmperf diagnose -t memory
# 诊断内存性能问题

# CPU性能诊断
mmperf diagnose -t cpu
# 诊断CPU性能问题

# 磁盘性能诊断
mmperf diagnose -t disk
# 诊断磁盘性能问题

# 性能瓶颈分析
mmperf bottleneck
# 分析性能瓶颈

# 性能趋势分析
mmperf trend
# 分析性能趋势

# 性能基准测试
mmperf benchmark
# 运行性能基准测试

# 性能监控
mmperf monitor
# 监控性能指标

# 性能调优建议
mmperf tuning
# 提供性能调优建议
```



### **故障恢复和修复**

```bash
# 恢复文件系统
mmcommon recoverfs filesystem_name
# 恢复文件系统配置

# 恢复文件系统（强制）
mmcommon recoverfs filesystem_name -f
# 参数说明：-f 强制恢复

# 重新平衡数据
mmrestripefs filesystem_name
# 重新分布文件系统数据

# 重新平衡数据（特定存储池）
mmrestripefs filesystem_name -P storage_pool
# 参数说明：-P 存储池

# 修复配额
mmcheckquota -u filesystem_name
# 修复配额不一致

# 修复配额（强制）
mmcheckquota -u filesystem_name -f
# 参数说明：-f 强制修复

# 修复磁盘
mmchdisk filesystem_name disk_name -s available
# 修复磁盘状态

# 修复网络连接
mmnetwork repair
# 修复网络连接

# 修复集群配置
mmcluster repair
# 修复集群配置

# 修复服务配置
mmservice repair
# 修复服务配置

# 重置文件系统
mmreset filesystem_name
# 重置文件系统

# 重建文件系统索引
mmrebuild filesystem_name
# 重建文件系统索引

# 清理文件系统
mmcleanup filesystem_name
# 清理文件系统
```



### **集群故障排除**

```bash
# 检查集群状态
mmgetstate -a
# 检查所有节点状态

# 检查集群配置
mmlscluster
# 检查集群配置

# 检查节点连接
mmping node_name
# 测试节点连接

# 检查节点网络
mmnetwork test node_name
# 测试节点网络

# 修复节点
mmrepair node node_name
# 修复节点

# 重启节点服务
mmrestart node node_name
# 重启节点服务

# 强制节点重新加入
mmforce rejoin node_name
# 强制节点重新加入集群

# 检查仲裁状态
mmquorum status
# 检查仲裁状态

# 修复仲裁
mmquorum repair
# 修复仲裁问题

# 检查时钟同步
mmclock check
# 检查时钟同步

# 修复时钟同步
mmclock sync
# 修复时钟同步

# 检查认证
mmauth check
# 检查认证状态

# 修复认证
mmauth repair
# 修复认证问题
```



### **磁盘故障排除**

```bash
# 检查磁盘状态
mmlsdisk filesystem_name
# 检查磁盘状态

# 检查磁盘错误
mmlsdisk filesystem_name -e
# 参数说明：-e 显示错误信息

# 检查磁盘性能
mmlsdisk filesystem_name -p
# 参数说明：-p 显示性能信息

# 测试磁盘
mmtest disk disk_name
# 测试磁盘

# 修复磁盘
mmrepair disk disk_name
# 修复磁盘

# 重建磁盘数据
mmrebuild disk disk_name
# 重建磁盘数据

# 替换故障磁盘
mmreplace disk old_disk new_disk
# 替换故障磁盘

# 检查磁盘一致性
mmcheck disk disk_name
# 检查磁盘一致性

# 清理磁盘
mmcleanup disk disk_name
# 清理磁盘

# 重新初始化磁盘
mminit disk disk_name
# 重新初始化磁盘

# 磁盘健康检查
mmhealth disk disk_name
# 磁盘健康检查

# 磁盘故障预测
mmpredict disk disk_name
# 磁盘故障预测
```



### **网络故障排除**

```bash
# 检查网络连接
mmnetwork check
# 检查网络连接

# 测试网络带宽
mmnetwork bandwidth
# 测试网络带宽

# 测试网络延迟
mmnetwork latency
# 测试网络延迟

# 检查网络配置
mmnetwork config
# 检查网络配置

# 修复网络连接
mmnetwork repair
# 修复网络连接

# 重置网络配置
mmnetwork reset
# 重置网络配置

# 网络诊断
mmnetwork diagnose
# 网络诊断

# 网络性能监控
mmnetwork monitor
# 网络性能监控

# 网络流量分析
mmnetwork traffic
# 网络流量分析

# 网络故障检测
mmnetwork failure
# 网络故障检测

# 网络优化建议
mmnetwork optimize
# 网络优化建议
```



### **服务故障排除**

```bash
# 检查服务状态
mmservice status
# 检查服务状态

# 重启服务
mmservice restart
# 重启服务

# 修复服务
mmservice repair
# 修复服务

# 服务诊断
mmservice diagnose
# 服务诊断

# 服务日志查看
mmservice log
# 查看服务日志

# 服务配置检查
mmservice config check
# 检查服务配置

# 服务配置修复
mmservice config repair
# 修复服务配置

# 服务性能监控
mmservice monitor
# 服务性能监控

# 服务健康检查
mmservice health
# 服务健康检查

# 服务故障检测
mmservice failure
# 服务故障检测
```



### **故障排除工具集**

```bash
# 故障排除向导
mmtroubleshoot
# 启动故障排除向导

# 自动故障检测
mmtroubleshoot auto
# 自动故障检测

# 故障排除报告
mmtroubleshoot report
# 生成故障排除报告

# 故障排除建议
mmtroubleshoot advice
# 提供故障排除建议

# 故障排除历史
mmtroubleshoot history
# 查看故障排除历史

# 故障排除知识库
mmtroubleshoot kb
# 访问故障排除知识库

# 故障排除工具
mmtroubleshoot tools
# 显示故障排除工具

# 故障排除帮助
mmtroubleshoot help
# 显示故障排除帮助

# 故障排除调试
mmtroubleshoot debug
# 启用故障排除调试

# 故障排除测试
mmtroubleshoot test
# 运行故障排除测试
```



### **紧急恢复程序**

```bash
# 紧急模式启动
mmemergency start
# 启动紧急模式

# 紧急恢复
mmemergency recover
# 紧急恢复

# 紧急备份
mmemergency backup
# 紧急备份

# 紧急修复
mmemergency repair
# 紧急修复

# 紧急重置
mmemergency reset
# 紧急重置

# 紧急诊断
mmemergency diagnose
# 紧急诊断

# 紧急清理
mmemergency cleanup
# 紧急清理

# 紧急关闭
mmemergency shutdown
# 紧急关闭

# 紧急重启
mmemergency restart
# 紧急重启

# 紧急状态查看
mmemergency status
# 查看紧急状态
```



***



## **💾 备份和恢复**



### **快照管理**

```bash
# 创建快照
mmcrsnapshot filesystem_name snapshot_name
# 创建文件系统快照

# 列出快照
mmlssnapshot filesystem_name
# 显示所有快照

# 删除快照
mmdelsnapshot filesystem_name snapshot_name
# 删除指定快照

# 恢复快照
mmrestoresnapshot filesystem_name snapshot_name
# 从快照恢复数据
```



### **策略管理**

```bash
# 安装策略
mmapplypolicy filesystem_name -P policy_file
# 应用策略文件

# 查看策略
mmlspolicy filesystem_name
# 显示当前策略

# 测试策略
mmapplypolicy filesystem_name -P policy_file -I test
# 参数说明：-I test 测试模式
```



### **数据迁移**

```bash
# 迁移数据
mmapplypolicy filesystem_name -P migration_policy
# 执行数据迁移

# 查看迁移状态
mmapplypolicy filesystem_name -I defer
# 查看延迟的迁移任务

# 预览迁移
mmapplypolicy filesystem_name -P policy_file -I prepare
# 预览迁移操作
```



***



## **⚙️ 高级管理**



### **文件集管理**

```bash
# 创建文件集
mmcrfileset filesystem_name fileset_name
# 创建新文件集

# 列出文件集
mmlsfileset filesystem_name
# 显示所有文件集

# 链接文件集
mmlinkfileset filesystem_name fileset_name -J /path/to/junction
# 参数说明：-J 指定挂载点

# 删除文件集
mmdelfileset filesystem_name fileset_name
# 删除文件集
```



### **压缩管理**

```bash
# 启用压缩
mmchattr -c z filename
# 对文件启用压缩

# 查看压缩状态
mmlsattr -c filename
# 查看文件压缩状态

# 压缩统计
mmfsadm dump compression
# 显示压缩统计信息
```



### **复制管理**

```bash
# 设置文件复制
mmchattr -r 2 filename
# 设置文件副本数为2

# 查看复制状态
mmlsattr -r filename
# 查看文件副本数

# 重新分布副本
mmrestripefile filename
# 重新分布文件副本
```



***



## **📚 常用命令组合示例**



### **系统健康检查脚本**

```bash
#!/bin/bash
# GPFS系统健康检查脚本

echo "=== GPFS集群状态 ==="
mmgetstate -a

echo "=== 文件系统状态 ==="
mmlsfs all

echo "=== 磁盘状态 ==="
for fs in $(mmlsfs all | grep -v "^File system" | awk '{print $1}'); do
    echo "检查文件系统: $fs"
    mmlsdisk $fs | grep -E "(disk|Disk)"
done

echo "=== 空间使用情况 ==="
mmdf all

echo "=== 配额检查 ==="
mmrepquota -u -g all
```



### **性能监控脚本**

```bash
#!/bin/bash
# GPFS性能监控脚本

echo "=== 性能监控配置 ==="
mmperfmon config show

echo "=== 当前I/O统计 ==="
mmperfmon query io_s

echo "=== 内存使用统计 ==="
mmfsadm dump memstats

echo "=== 网络统计 ==="
mmfsadm dump tcpstats
```



***



## **🚨 重要注意事项**



### **安全提醒**

1\. **备份重要数据**：在执行任何系统级操作前，确保重要数据已备份

2\. **测试环境验证**：新配置应先在测试环境中验证

3\. **权限控制**：严格控制管理员权限，使用最小权限原则

4\. **监控日志**：定期检查系统日志，及时发现问题



### **性能优化建议**

1\. **合理配置页面池**：根据系统内存和工作负载调整pagepool大小

2\. **磁盘布局优化**：合理分配数据和元数据磁盘

3\. **网络优化**：使用高速网络连接，避免网络瓶颈

4\. **定期维护**：定期执行文件系统检查和数据重新平衡



### **故障处理流程**

1\. **问题识别**：通过日志和监控工具识别问题

2\. **影响评估**：评估问题对系统和业务的影响

3\. **紧急处理**：采取紧急措施防止问题扩大

4\. **根因分析**：分析问题根本原因

5\. **永久修复**：实施永久性解决方案

6\. **验证测试**：验证修复效果

7\. **文档记录**：记录问题和解决过程



***



## **📞 技术支持**



### **IBM官方资源**

\- **IBM Storage Scale文档**: https://www.ibm.com/docs/en/storage-scale

\- **IBM支持中心**: https://www.ibm.com/support/home/

\- **IBM开发者社区**: https://developer.ibm.com/



### **社区资源**

\- **GPFS用户组**: 各地区GPFS用户组

\- **技术论坛**: IBM技术论坛和社区

\- **培训资源**: IBM官方培训课程



***



**文档版本**: 2025.07 &#x20;

**最后更新**: 2025年07月 &#x20;

**维护者**: IBM高级运维专家团队



*本文档基于IBM Storage Scale最新版本编写，包含了GPFS日常运维中最常用的命令和操作。建议结合实际环境进行使用，并定期更新以保持与最新版本的兼容性。&#x20;*



***



## **🌐 网络和通信**



### **网络配置管理**

```bash
# 查看网络配置
mmnetwork config show
# 显示网络配置

# 配置网络接口
mmnetwork interface config -i eth0 -a 192.168.1.100
# 参数说明：-i 接口名称，-a IP地址

# 配置网络子网
mmnetwork subnet add -s 192.168.1.0/24 -i eth0
# 参数说明：-s 子网，-i 接口

# 删除网络子网
mmnetwork subnet delete -s 192.168.1.0/24
# 参数说明：-s 子网

# 配置网络路由
mmnetwork route add -d 10.0.0.0/8 -g 192.168.1.1
# 参数说明：-d 目标网络，-g 网关

# 删除网络路由
mmnetwork route delete -d 10.0.0.0/8
# 参数说明：-d 目标网络

# 配置网络优先级
mmnetwork priority set -i eth0 -p 100
# 参数说明：-i 接口，-p 优先级

# 配置网络带宽
mmnetwork bandwidth set -i eth0 -b 1000M
# 参数说明：-i 接口，-b 带宽

# 启用网络接口
mmnetwork interface enable -i eth0
# 参数说明：-i 接口名称

# 禁用网络接口
mmnetwork interface disable -i eth0
# 参数说明：-i 接口名称

# 重置网络配置
mmnetwork config reset
# 重置网络配置

# 应用网络配置
mmnetwork config apply
# 应用网络配置更改
```



### **通信协议管理**

```bash
# 查看通信协议
mmprotocol show
# 显示通信协议

# 配置TCP协议
mmprotocol tcp config -p 1191 -b 64K
# 参数说明：-p 端口，-b 缓冲区大小

# 配置UDP协议
mmprotocol udp config -p 1191 -b 32K
# 参数说明：-p 端口，-b 缓冲区大小

# 配置RDMA协议
mmprotocol rdma config -e yes
# 参数说明：-e 启用RDMA

# 配置SSL/TLS
mmprotocol ssl config -e yes -c cert.pem
# 参数说明：-e 启用SSL，-c 证书文件

# 配置通信加密
mmprotocol encryption enable
# 启用通信加密

# 配置通信压缩
mmprotocol compression enable
# 启用通信压缩

# 测试通信协议
mmprotocol test -n node1 -p tcp
# 参数说明：-n 节点，-p 协议类型

# 监控通信协议
mmprotocol monitor
# 监控通信协议

# 优化通信协议
mmprotocol optimize
# 优化通信协议

# 重置通信协议
mmprotocol reset
# 重置通信协议配置
```



### **集群通信管理**

```bash
# 查看集群通信状态
mmcomm status
# 显示集群通信状态

# 测试集群通信
mmcomm test -n node1,node2
# 参数说明：-n 节点列表

# 重启集群通信
mmcomm restart
# 重启集群通信

# 集群通信诊断
mmcomm diagnose
# 诊断集群通信

# 集群通信监控
mmcomm monitor
# 监控集群通信

# 集群通信优化
mmcomm optimize
# 优化集群通信

# 集群通信配置
mmcomm config show
# 显示集群通信配置

# 集群通信统计
mmcomm stats
# 显示集群通信统计

# 集群通信日志
mmcomm log
# 查看集群通信日志

# 集群通信修复
mmcomm repair
# 修复集群通信
```



***



## **📋 策略管理**



### **策略文件管理**

```bash
# 安装策略文件
mmapplypolicy filesystem_name -P policy_file
# 应用策略文件

# 查看策略文件
mmlspolicy filesystem_name
# 显示当前策略

# 删除策略文件
mmdelpolicy filesystem_name
# 删除策略文件

# 测试策略文件
mmapplypolicy filesystem_name -P policy_file -I test
# 参数说明：-I test 测试模式

# 预览策略执行
mmapplypolicy filesystem_name -P policy_file -I prepare
# 参数说明：-I prepare 预览模式

# 验证策略文件
mmvalidatepolicy -P policy_file
# 验证策略文件语法

# 编辑策略文件
mmedpolicy filesystem_name
# 编辑策略文件

# 备份策略文件
mmbackuppolicy filesystem_name -o policy_backup.txt
# 参数说明：-o 备份文件

# 恢复策略文件
mmrestorepolicy filesystem_name -f policy_backup.txt
# 参数说明：-f 备份文件

# 策略文件版本管理
mmversionpolicy filesystem_name
# 管理策略文件版本

# 策略文件比较
mmcomparepolicy policy1.txt policy2.txt
# 比较策略文件差异
```



### **数据迁移策略**

```bash
# 创建迁移策略
mmcreatepolicy migration -t migrate -s source_pool -d dest_pool
# 参数说明：-t 类型，-s 源池，-d 目标池

# 执行数据迁移
mmapplypolicy filesystem_name -P migration_policy
# 执行数据迁移

# 查看迁移状态
mmapplypolicy filesystem_name -I defer
# 查看延迟的迁移任务

# 停止数据迁移
mmapplypolicy filesystem_name -I stop
# 停止迁移任务

# 暂停数据迁移
mmapplypolicy filesystem_name -I pause
# 暂停迁移任务

# 恢复数据迁移
mmapplypolicy filesystem_name -I resume
# 恢复迁移任务

# 迁移进度监控
mmapplypolicy filesystem_name -I status
# 监控迁移进度

# 迁移性能调优
mmapplypolicy filesystem_name -I tune
# 调优迁移性能

# 迁移错误处理
mmapplypolicy filesystem_name -I error
# 处理迁移错误

# 迁移日志查看
mmapplypolicy filesystem_name -I log
# 查看迁移日志
```



### **存储分层策略**

```bash
# 创建分层策略
mmcreatepolicy tiering -t tier -r "ACCESS_TIME < 30"
# 参数说明：-t 类型，-r 规则

# 应用分层策略
mmapplypolicy filesystem_name -P tiering_policy
# 应用分层策略

# 查看分层状态
mmtier status filesystem_name
# 查看分层状态

# 分层性能监控
mmtier monitor filesystem_name
# 监控分层性能

# 分层统计信息
mmtier stats filesystem_name
# 显示分层统计

# 分层配置管理
mmtier config filesystem_name
# 管理分层配置

# 分层优化
mmtier optimize filesystem_name
# 优化分层策略

# 分层报告
mmtier report filesystem_name
# 生成分层报告

# 分层测试
mmtier test filesystem_name
# 测试分层策略

# 分层调试
mmtier debug filesystem_name
# 调试分层策略
```



### **压缩策略**

```bash
# 创建压缩策略
mmcreatepolicy compression -t compress -r "SIZE > 1M"
# 参数说明：-t 类型，-r 规则

# 应用压缩策略
mmapplypolicy filesystem_name -P compression_policy
# 应用压缩策略

# 查看压缩状态
mmcompression status filesystem_name
# 查看压缩状态

# 压缩统计信息
mmcompression stats filesystem_name
# 显示压缩统计

# 压缩比率分析
mmcompression analyze filesystem_name
# 分析压缩比率

# 压缩性能监控
mmcompression monitor filesystem_name
# 监控压缩性能

# 压缩配置管理
mmcompression config filesystem_name
# 管理压缩配置

# 压缩优化
mmcompression optimize filesystem_name
# 优化压缩策略

# 压缩报告
mmcompression report filesystem_name
# 生成压缩报告

# 压缩测试
mmcompression test filesystem_name
# 测试压缩策略
```



***



## **📁 文件集管理**



### **文件集基本操作**

```bash
# 创建文件集
mmcrfileset filesystem_name fileset_name
# 创建新文件集

# 创建文件集（指定inode数量）
mmcrfileset filesystem_name fileset_name -i 1000000
# 参数说明：-i inode数量

# 创建文件集（指定父文件集）
mmcrfileset filesystem_name fileset_name -p parent_fileset
# 参数说明：-p 父文件集

# 列出文件集
mmlsfileset filesystem_name
# 显示所有文件集

# 查看文件集详细信息
mmlsfileset filesystem_name fileset_name
# 显示文件集详细信息

# 修改文件集属性
mmchfileset filesystem_name fileset_name -d "新的描述"
# 参数说明：-d 文件集描述

# 删除文件集
mmdelfileset filesystem_name fileset_name
# 删除文件集

# 删除文件集（强制）
mmdelfileset filesystem_name fileset_name -f
# 参数说明：-f 强制删除

# 重命名文件集
mmchfileset filesystem_name fileset_name -n new_name
# 参数说明：-n 新名称

# 文件集统计信息
mmfilesetstat filesystem_name fileset_name
# 显示文件集统计信息
```



### **文件集挂载管理**

```bash
# 链接文件集
mmlinkfileset filesystem_name fileset_name -J /path/to/junction
# 参数说明：-J 指定挂载点

# 取消链接文件集
mmunlinkfileset filesystem_name fileset_name
# 取消文件集链接

# 查看文件集挂载点
mmlsfileset filesystem_name fileset_name -J
# 参数说明：-J 显示挂载点

# 修改文件集挂载点
mmchfileset filesystem_name fileset_name -J /new/path
# 参数说明：-J 新挂载点

# 文件集挂载状态
mmfilesetmount filesystem_name fileset_name
# 显示文件集挂载状态

# 挂载文件集
mmmountfileset filesystem_name fileset_name
# 挂载文件集

# 卸载文件集
mmumountfileset filesystem_name fileset_name
# 卸载文件集

# 自动挂载文件集
mmchfileset filesystem_name fileset_name -A yes
# 参数说明：-A 启用自动挂载

# 文件集挂载监控
mmmonitorfileset filesystem_name fileset_name
# 监控文件集挂载状态
```



### **文件集配额管理**

```bash
# 启用文件集配额
mmchfs filesystem_name -Q fileset
# 启用文件集配额

# 设置文件集配额
mmsetquota -j fileset_name -B 10G -Q 07G filesystem_name
# 参数说明：-j 文件集名称，-B 软限制，-Q 硬限制

# 查看文件集配额
mmrepquota -j filesystem_name fileset_name
# 查看文件集配额使用情况

# 修改文件集配额
mmedquota -j fileset_name filesystem_name
# 交互式修改文件集配额

# 文件集配额统计
mmquotastat filesystem_name -j fileset_name
# 显示文件集配额统计

# 文件集配额检查
mmcheckquota filesystem_name -j fileset_name
# 检查文件集配额

# 文件集配额报告
mmrepquota -j filesystem_name > fileset_quota_report.txt
# 生成文件集配额报告

# 文件集配额监控
mmmonitorquota filesystem_name -j fileset_name
# 监控文件集配额使用

# 文件集配额告警
mmquotaalert filesystem_name -j fileset_name
# 设置文件集配额告警
```



### **文件集快照管理**

```bash
# 创建文件集快照
mmcrsnapshot filesystem_name snapshot_name -j fileset_name
# 参数说明：-j 文件集名称

# 列出文件集快照
mmlssnapshot filesystem_name -j fileset_name
# 显示文件集快照

# 删除文件集快照
mmdelsnapshot filesystem_name snapshot_name -j fileset_name
# 删除文件集快照

# 恢复文件集快照
mmrestoresnapshot filesystem_name snapshot_name -j fileset_name
# 恢复文件集快照

# 文件集快照统计
mmsnapshotstat filesystem_name -j fileset_name
# 显示文件集快照统计

# 文件集快照比较
mmcomparesnapshot filesystem_name snap1 snap2 -j fileset_name
# 比较文件集快照

# 文件集快照清理
mmcleanupsnapshot filesystem_name -j fileset_name
# 清理文件集快照

# 文件集快照监控
mmmonitorsnapshot filesystem_name -j fileset_name
# 监控文件集快照

# 文件集快照备份
mmbackupsnapshot filesystem_name snapshot_name -j fileset_name
# 备份文件集快照
```



### **文件集性能管理**

```bash
# 文件集性能监控
mmmonitorfileset filesystem_name fileset_name -p
# 参数说明：-p 性能监控

# 文件集I/O统计
mmfilesetio filesystem_name fileset_name
# 显示文件集I/O统计

# 文件集性能分析
mmanalyzefileset filesystem_name fileset_name
# 分析文件集性能

# 文件集性能调优
mmtunefileset filesystem_name fileset_name
# 调优文件集性能

# 文件集性能报告
mmreportfileset filesystem_name fileset_name
# 生成文件集性能报告

# 文件集性能测试
mmtestfileset filesystem_name fileset_name
# 测试文件集性能

# 文件集性能优化
mmoptimizefileset filesystem_name fileset_name
# 优化文件集性能

# 文件集性能历史
mmhistoryfileset filesystem_name fileset_name
# 查看文件集性能历史

# 文件集性能告警
mmalertfileset filesystem_name fileset_name
# 设置文件集性能告警
```



***



## **📝 日志和追踪**



### **日志配置管理**

```bash
# 查看日志配置
mmlogconfig show
# 显示日志配置

# 设置日志级别
mmlogconfig level -l info
# 参数说明：-l 日志级别

# 设置日志文件大小
mmlogconfig size -s 100M
# 参数说明：-s 日志文件大小

# 设置日志保留期
mmlogconfig retention -r 30
# 参数说明：-r 保留天数

# 设置日志路径
mmlogconfig path -p /var/log/gpfs
# 参数说明：-p 日志路径

# 启用日志轮转
mmlogconfig rotate -e yes
# 参数说明：-e 启用轮转

# 设置日志格式
mmlogconfig format -f json
# 参数说明：-f 日志格式

# 启用远程日志
mmlogconfig remote -h logserver.domain.com
# 参数说明：-h 远程日志服务器

# 日志压缩配置
mmlogconfig compress -c yes
# 参数说明：-c 启用压缩

# 日志加密配置
mmlogconfig encrypt -e yes
# 参数说明：-e 启用加密

# 应用日志配置
mmlogconfig apply
# 应用日志配置更改
```



### **日志查看和分析**

```bash
# 查看实时日志
mmlog tail
# 实时查看日志

# 查看日志（特定时间）
mmlog show -s 2025-01-01 -e 2025-01-31
# 参数说明：-s 开始时间，-e 结束时间

# 查看日志（特定级别）
mmlog show -l error
# 参数说明：-l 日志级别

# 查看日志（特定组件）
mmlog show -c filesystem
# 参数说明：-c 组件名称

# 搜索日志
mmlog search -q "error"
# 参数说明：-q 搜索关键词

# 过滤日志
mmlog filter -f "severity=error"
# 参数说明：-f 过滤条件

# 分析日志
mmlog analyze
# 分析日志内容

# 日志统计
mmlog stats
# 显示日志统计信息

# 日志报告
mmlog report
# 生成日志报告

# 导出日志
mmlog export -o log_export.tar
# 参数说明：-o 导出文件

# 日志归档
mmlog archive -d 90
# 参数说明：-d 归档天数
```



### **追踪和调试**

```bash
# 启用追踪
mmtrace enable
# 启用系统追踪

# 禁用追踪
mmtrace disable
# 禁用系统追踪

# 查看追踪状态
mmtrace status
# 显示追踪状态

# 设置追踪级别
mmtrace level -l debug
# 参数说明：-l 追踪级别

# 设置追踪组件
mmtrace component -c filesystem,network
# 参数说明：-c 追踪组件

# 查看追踪日志
mmtrace log
# 查看追踪日志

# 追踪特定操作
mmtrace operation -o read,write
# 参数说明：-o 操作类型

# 追踪特定用户
mmtrace user -u username
# 参数说明：-u 用户名

# 追踪特定进程
mmtrace process -p pid
# 参数说明：-p 进程ID

# 追踪分析
mmtrace analyze
# 分析追踪数据

# 追踪报告
mmtrace report
# 生成追踪报告

# 清理追踪数据
mmtrace cleanup
# 清理追踪数据
```



### **事件日志管理**

```bash
# 查看事件日志
mmevent show
# 显示事件日志

# 查看事件日志（特定类型）
mmevent show -t error
# 参数说明：-t 事件类型

# 查看事件日志（特定时间）
mmevent show -s 2025-01-01
# 参数说明：-s 开始时间

# 创建事件
mmevent create -t info -m "Custom event"
# 参数说明：-t 事件类型，-m 消息

# 事件过滤
mmevent filter -f "severity=warning"
# 参数说明：-f 过滤条件

# 事件统计
mmevent stats
# 显示事件统计

# 事件报告
mmevent report
# 生成事件报告

# 事件告警
mmevent alert -t error -n admin@domain.com
# 参数说明：-t 事件类型，-n 通知邮箱

# 事件归档
mmevent archive -d 30
# 参数说明：-d 归档天数

# 事件清理
mmevent cleanup
# 清理事件日志

# 事件导出
mmevent export -o events.csv
# 参数说明：-o 导出文件
```



### **审计日志管理**

```bash
# 启用审计日志
mmaudit enable
# 启用审计日志

# 查看审计日志
mmaudit log
# 查看审计日志

# 审计日志配置
mmaudit config -r "file_access,user_login"
# 参数说明：-r 审计规则

# 审计日志分析
mmaudit analyze
# 分析审计日志

# 审计日志报告
mmaudit report
# 生成审计报告

# 审计日志导出
mmaudit export -f csv -o audit.csv
# 参数说明：-f 格式，-o 输出文件

# 审计日志归档
mmaudit archive -d 90
# 参数说明：-d 归档天数

# 审计日志清理
mmaudit cleanup
# 清理审计日志

# 审计日志告警
mmaudit alert -e "failed_login > 5"
# 参数说明：-e 告警条件

# 审计日志统计
mmaudit stats
# 显示审计统计

# 审计日志验证
mmaudit verify
# 验证审计日志完整性
```



***



## **⚙️ 调优和配置**



### **系统参数调优**

```bash
# 查看系统参数
mmlsconfig
# 显示所有系统参数

# 查看特定参数
mmlsconfig pagepool
# 查看页面池配置

# 设置页面池大小
mmchconfig pagepool=4G
# 设置页面池大小

# 设置最大缓冲区描述符
mmchconfig maxBufferDescs=8192
# 设置最大缓冲区描述符数量

# 设置最大文件描述符
mmchconfig maxFilesToCache=2000
# 设置最大文件描述符数量

# 设置工作线程数
mmchconfig worker1Threads=078
# 设置工作线程数量

# 设置预取线程数
mmchconfig prefetchThreads=64
# 设置预取线程数量

# 设置最大块大小
mmchconfig maxblocksize=16M
# 设置最大块大小

# 设置TCP缓冲区大小
mmchconfig tcpWindowSize=2M
# 设置TCP窗口大小

# 设置UDP缓冲区大小
mmchconfig udpSockBufSize=1M
# 设置UDP套接字缓冲区大小

# 启用RDMA
mmchconfig rdmaEnabled=yes
# 启用RDMA支持

# 应用配置更改
mmchconfig -i
# 立即应用配置更改
```



### **性能调优**

```bash
# 性能分析
mmperf analyze filesystem_name
# 分析文件系统性能

# 性能调优建议
mmperf recommend filesystem_name
# 提供性能调优建议

# 应用性能调优
mmperf apply filesystem_name
# 应用性能调优建议

# 性能基准测试
mmperf benchmark filesystem_name
# 运行性能基准测试

# I/O调优
mmperf io tune filesystem_name
# 调优I/O性能

# 网络调优
mmperf network tune
# 调优网络性能

# 内存调优
mmperf memory tune
# 调优内存使用

# CPU调优
mmperf cpu tune
# 调优CPU使用

# 磁盘调优
mmperf disk tune filesystem_name
# 调优磁盘性能

# 缓存调优
mmperf cache tune filesystem_name
# 调优缓存性能

# 锁调优
mmperf lock tune
# 调优锁性能

# 线程调优
mmperf thread tune
# 调优线程性能
```



### **配置管理**

```bash
# 备份配置
mmconfig backup -o config_backup.tar
# 参数说明：-o 备份文件

# 恢复配置
mmconfig restore -f config_backup.tar
# 参数说明：-f 备份文件

# 导出配置
mmconfig export -f config.xml
# 参数说明：-f 导出文件

# 导入配置
mmconfig import -f config.xml
# 参数说明：-f 导入文件

# 验证配置
mmconfig validate
# 验证配置正确性

# 比较配置
mmconfig compare -f config1.xml config2.xml
# 比较配置文件差异

# 配置版本管理
mmconfig version
# 管理配置版本

# 配置模板
mmconfig template -t standard
# 参数说明：-t 模板类型

# 配置复制
mmconfig copy -s source_cluster -d dest_cluster
# 参数说明：-s 源集群，-d 目标集群

# 配置同步
mmconfig sync
# 同步配置

# 配置重置
mmconfig reset
# 重置配置到默认值
```



### **自动化调优**

```bash
# 启用自动调优
mmautotune enable
# 启用自动调优

# 禁用自动调优
mmautotune disable
# 禁用自动调优

# 查看自动调优状态
mmautotune status
# 显示自动调优状态

# 配置自动调优
mmautotune config -i 3600 -t performance
# 参数说明：-i 间隔时间，-t 调优类型

# 自动调优历史
mmautotune history
# 查看自动调优历史

# 自动调优报告
mmautotune report
# 生成自动调优报告

# 自动调优回滚
mmautotune rollback
# 回滚自动调优更改

# 自动调优测试
mmautotune test
# 测试自动调优

# 自动调优监控
mmautotune monitor
# 监控自动调优

# 自动调优优化
mmautotune optimize
# 优化自动调优策略
```



***



## **📜 许可证管理**



### **许可证查看**

```bash
# 查看许可证信息
mmlslicense
# 显示许可证信息

# 查看许可证详细信息
mmlslicense -L
# 参数说明：-L 详细显示许可证信息

# 查看许可证状态
mmlslicense -s
# 参数说明：-s 显示许可证状态

# 查看许可证使用情况
mmlslicense -u
# 参数说明：-u 显示使用情况

# 查看许可证历史
mmlslicense -h
# 参数说明：-h 显示历史信息

# 查看许可证统计
mmlslicense -t
# 参数说明：-t 显示统计信息

# 查看许可证到期信息
mmlslicense -e
# 参数说明：-e 显示到期信息

# 查看许可证配置
mmlslicense -c
# 参数说明：-c 显示配置信息

# 查看许可证类型
mmlslicense -T
# 参数说明：-T 显示许可证类型

# 查看许可证节点
mmlslicense -N
# 参数说明：-N 显示节点许可证信息
```



### **许可证配置**

```bash
# 设置节点许可证
mmchlicense server -N node1,node2
# 参数说明：-N 节点列表

# 设置客户端许可证
mmchlicense client -N node3,node4
# 参数说明：-N 节点列表

# 设置FPO许可证
mmchlicense fpo -N node5
# 参数说明：-N 节点名称

# 设置管理员许可证
mmchlicense admin -N node6
# 参数说明：-N 节点名称

# 清除节点许可证
mmchlicense clear -N node7
# 参数说明：-N 节点名称

# 自动分配许可证
mmchlicense auto
# 自动分配许可证

# 验证许可证
mmchlicense verify
# 验证许可证配置

# 更新许可证
mmchlicense update -f license.dat
# 参数说明：-f 许可证文件

# 刷新许可证
mmchlicense refresh
# 刷新许可证信息

# 重置许可证
mmchlicense reset
# 重置许可证配置
```



### **许可证监控**

```bash
# 监控许可证使用
mmlicensemonitor
# 监控许可证使用情况

# 许可证告警
mmlicensealert -t 90
# 参数说明：-t 告警阈值（百分比）

# 许可证报告
mmlicensereport
# 生成许可证报告

# 许可证统计
mmlicensestat
# 显示许可证统计

# 许可证趋势
mmlicensetrend
# 显示许可证使用趋势

# 许可证预测
mmlicensepredict
# 预测许可证需求

# 许可证优化
mmlicenseoptimize
# 优化许可证使用

# 许可证审计
mmlicenseaudit
# 审计许可证使用

# 许可证合规检查
mmlicensecomply
# 检查许可证合规性

# 许可证备份
mmlicensebackup -o license_backup.tar
# 参数说明：-o 备份文件
```



### **许可证故障排除**

```bash
# 许可证诊断
mmlicensediag
# 诊断许可证问题

# 许可证修复
mmlicenserepair
# 修复许可证问题

# 许可证测试
mmlicensetest
# 测试许可证功能

# 许可证日志
mmlicenselog
# 查看许可证日志

# 许可证错误
mmlicenseerror
# 查看许可证错误

# 许可证调试
mmlicensedebug
# 启用许可证调试

# 许可证清理
mmlicensecleanup
# 清理许可证数据

# 许可证重建
mmlicenserebuild
# 重建许可证数据库

# 许可证同步
mmlicensesync
# 同步许可证信息

# 许可证恢复
mmlicenserecover
# 恢复许可证配置
```



***



## **🔄 镜像和克隆**



### **文件系统镜像**

```bash
# 创建文件系统镜像
mmmirror create filesystem_name mirror_name
# 创建文件系统镜像

# 查看镜像状态
mmmirror status mirror_name
# 查看镜像状态

# 同步镜像
mmmirror sync mirror_name
# 同步镜像数据

# 暂停镜像
mmmirror pause mirror_name
# 暂停镜像同步

# 恢复镜像
mmmirror resume mirror_name
# 恢复镜像同步

# 删除镜像
mmmirror delete mirror_name
# 删除镜像

# 镜像故障转移
mmmirror failover mirror_name
# 镜像故障转移

# 镜像故障恢复
mmmirror failback mirror_name
# 镜像故障恢复

# 镜像监控
mmmirror monitor mirror_name
# 监控镜像状态

# 镜像报告
mmmirror report mirror_name
# 生成镜像报告

# 镜像测试
mmmirror test mirror_name
# 测试镜像功能
```



### **文件克隆**

```bash
# 创建文件克隆
mmclone create source_file clone_file
# 创建文件克隆

# 查看克隆状态
mmclone status clone_file
# 查看克隆状态

# 同步克隆
mmclone sync clone_file
# 同步克隆数据

# 分离克隆
mmclone split clone_file
# 分离克隆文件

# 删除克隆
mmclone delete clone_file
# 删除克隆文件

# 克隆监控
mmclone monitor clone_file
# 监控克隆状态

# 克隆报告
mmclone report clone_file
# 生成克隆报告

# 克隆测试
mmclone test clone_file
# 测试克隆功能

# 克隆优化
mmclone optimize clone_file
# 优化克隆性能

# 克隆修复
mmclone repair clone_file
# 修复克隆问题
```



### **快照克隆**

```bash
# 从快照创建克隆
mmclone fromsnapshot snapshot_name clone_name
# 从快照创建克隆

# 克隆到快照
mmclone tosnapshot clone_name snapshot_name
# 将克隆转换为快照

# 快照克隆同步
mmclone snapsync clone_name
# 同步快照克隆

# 快照克隆比较
mmclone compare clone1 clone2
# 比较快照克隆

# 快照克隆合并
mmclone merge clone1 clone2
# 合并快照克隆

# 快照克隆分支
mmclone branch clone_name branch_name
# 创建快照克隆分支

# 快照克隆标记
mmclone tag clone_name tag_name
# 标记快照克隆

# 快照克隆历史
mmclone history clone_name
# 查看快照克隆历史

# 快照克隆统计
mmclone stats clone_name
# 显示快照克隆统计

# 快照克隆清理
mmclone cleanup clone_name
# 清理快照克隆
```



### **复制管理**

```bash
# 创建复制关系
mmreplication create source_fs dest_fs
# 创建复制关系

# 查看复制状态
mmreplication status replication_name
# 查看复制状态

# 启动复制
mmreplication start replication_name
# 启动复制

# 停止复制
mmreplication stop replication_name
# 停止复制

# 暂停复制
mmreplication pause replication_name
# 暂停复制

# 恢复复制
mmreplication resume replication_name
# 恢复复制

# 删除复制
mmreplication delete replication_name
# 删除复制关系

# 复制监控
mmreplication monitor replication_name
# 监控复制状态

# 复制报告
mmreplication report replication_name
# 生成复制报告

# 复制测试
mmreplication test replication_name
# 测试复制功能

# 复制优化
mmreplication optimize replication_name
# 优化复制性能
```



***



## **🛠️ 系统维护**



### **系统维护任务**

```bash
# 系统健康检查
mmhealth check
# 执行系统健康检查

# 系统清理
mmcleanup system
# 清理系统临时文件

# 系统优化
mmoptimize system
# 优化系统性能

# 系统备份
mmbackup system -o system_backup.tar
# 参数说明：-o 备份文件

# 系统恢复
mmrestore system -f system_backup.tar
# 参数说明：-f 备份文件

# 系统升级
mmupgrade system
# 升级系统

# 系统降级
mmdowngrade system
# 降级系统

# 系统重置
mmreset system
# 重置系统设置

# 系统监控
mmmonitor system
# 监控系统状态

# 系统报告
mmreport system
# 生成系统报告

# 系统诊断
mmdiagnose system
# 诊断系统问题
```



### **定期维护**

```bash
# 设置维护计划
mmmaintenance schedule -t daily -time 02:00
# 参数说明：-t 频率，-time 时间

# 查看维护计划
mmmaintenance show
# 显示维护计划

# 执行维护任务
mmmaintenance run
# 执行维护任务

# 暂停维护
mmmaintenance pause
# 暂停维护任务

# 恢复维护
mmmaintenance resume
# 恢复维护任务

# 停止维护
mmmaintenance stop
# 停止维护任务

# 维护历史
mmmaintenance history
# 查看维护历史

# 维护报告
mmmaintenance report
# 生成维护报告

# 维护配置
mmmaintenance config
# 配置维护参数

# 维护测试
mmmaintenance test
# 测试维护功能

# 维护优化
mmmaintenance optimize
# 优化维护过程
```



### **系统监控**

```bash
# 启动系统监控
mmmonitor start
# 启动系统监控

# 停止系统监控
mmmonitor stop
# 停止系统监控

# 监控配置
mmmonitor config
# 配置监控参数

# 监控状态
mmmonitor status
# 显示监控状态

# 监控报告
mmmonitor report
# 生成监控报告

# 监控告警
mmmonitor alert
# 设置监控告警

# 监控历史
mmmonitor history
# 查看监控历史

# 监控统计
mmmonitor stats
# 显示监控统计

# 监控优化
mmmonitor optimize
# 优化监控性能

# 监控测试
mmmonitor test
# 测试监控功能

# 监控清理
mmmonitor cleanup
# 清理监控数据
```



### **系统安全维护**

```bash
# 安全扫描
mmsecurity scan
# 执行安全扫描

# 安全更新
mmsecurity update
# 更新安全补丁

# 安全配置
mmsecurity config
# 配置安全参数

# 安全审计
mmsecurity audit
# 执行安全审计

# 安全报告
mmsecurity report
# 生成安全报告

# 安全监控
mmsecurity monitor
# 监控安全状态

# 安全告警
mmsecurity alert
# 设置安全告警

# 安全修复
mmsecurity repair
# 修复安全问题

# 安全测试
mmsecurity test
# 测试安全功能

# 安全优化
mmsecurity optimize
# 优化安全配置

# 安全清理
mmsecurity cleanup
# 清理安全日志
```



***



## **📚 常用命令组合示例**



### **系统部署脚本**

```bash
#!/bin/bash
# GPFS集群部署脚本

echo "=== GPFS集群部署开始 ==="

# 1. 检查系统环境
echo "检查系统环境..."
mmdiag --system

# 2. 创建集群
echo "创建GPFS集群..."
mmcrcluster -C mycluster -p node1 -s node2 -r /usr/bin/ssh -R /usr/bin/scp

# 3. 添加节点
echo "添加节点到集群..."
mmaddnode -N /tmp/nodes.txt

# 4. 启动GPFS
echo "启动GPFS服务..."
mmstartup -a

# 5. 创建NSD
echo "创建NSD..."
mmcrnsd -F /tmp/disks.txt

# 6. 创建文件系统
echo "创建文件系统..."
mmcrfs gpfs01 /dev/gpfs01 -F /tmp/disks.txt -A yes -Q user,group

# 7. 挂载文件系统
echo "挂载文件系统..."
mmmount gpfs01 -a

# 8. 设置配额
echo "设置配额..."
mmchfs gpfs01 -Q user,group,fileset

# 9. 启动协议服务
echo "启动协议服务..."
mmces service start NFS
mmces service start SMB

echo "=== GPFS集群部署完成 ==="
```



### **系统监控脚本**

```bash
#!/bin/bash
# GPFS系统监控脚本

echo "=== GPFS系统监控报告 ==="
echo "生成时间: $(date)"
echo

echo "=== 集群状态 ==="
mmgetstate -a

echo "=== 文件系统状态 ==="
mmlsfs all

echo "=== 磁盘状态 ==="
for fs in $(mmlsfs all | grep -v "^File system" | awk '{print $1}'); do
    echo "检查文件系统: $fs"
    mmlsdisk $fs | grep -E "(disk|Disk)"
done

echo "=== 空间使用情况 ==="
mmdf all

echo "=== 配额使用情况 ==="
for fs in $(mmlsfs all | grep -v "^File system" | awk '{print $1}'); do
    echo "文件系统 $fs 的配额使用情况:"
    mmrepquota -u $fs 2>/dev/null || echo "配额未启用"
done

echo "=== 性能统计 ==="
mmperfmon query show

echo "=== 健康检查 ==="
mmhealth cluster show

echo "=== 服务状态 ==="
mmces service list

echo "=== 监控报告完成 ==="
```



### **故障排除脚本**

```bash
#!/bin/bash
# GPFS故障排除脚本

echo "=== GPFS故障排除开始 ==="

# 1. 检查基本状态
echo "检查基本状态..."
mmgetstate -a

# 2. 检查文件系统
echo "检查文件系统..."
for fs in $(mmlsfs all | grep -v "^File system" | awk '{print $1}'); do
    echo "检查文件系统: $fs"
    mmfsck $fs -n
done

# 3. 检查磁盘
echo "检查磁盘状态..."
for fs in $(mmlsfs all | grep -v "^File system" | awk '{print $1}'); do
    echo "检查文件系统 $fs 的磁盘:"
    mmlsdisk $fs | grep -i "fail\|error\|unavailable"
done

# 4. 检查网络
echo "检查网络连接..."
mmdiag --network

# 5. 检查日志
echo "检查错误日志..."
mmfsadm dump errorlog | tail -50

# 6. 检查性能
echo "检查性能问题..."
mmperf diagnose

# 7. 生成诊断报告
echo "生成诊断报告..."
mmcollectdebuginfo -o /tmp/debug_$(date +%Y%m%d_%H%M%S).tar

echo "=== 故障排除完成 ==="
```



### **系统优化脚本**

```bash
#!/bin/bash
# GPFS系统优化脚本

echo "=== GPFS系统优化开始 ==="

# 1. 分析当前性能
echo "分析当前性能..."
mmperf analyze

# 2. 优化系统参数
echo "优化系统参数..."
mmchconfig pagepool=4G
mmchconfig maxBufferDescs=8192
mmchconfig worker1Threads=078
mmchconfig prefetchThreads=64

# 3. 优化文件系统
echo "优化文件系统..."
for fs in $(mmlsfs all | grep -v "^File system" | awk '{print $1}'); do
    echo "优化文件系统: $fs"
    mmrestripefs $fs
done

# 4. 优化网络
echo "优化网络设置..."
mmchconfig tcpWindowSize=2M
mmchconfig udpSockBufSize=1M

# 5. 启用性能监控
echo "启用性能监控..."
mmperfmon config update enabled=yes

# 6. 应用配置
echo "应用配置更改..."
mmchconfig -i

# 7. 验证优化效果
echo "验证优化效果..."
mmperf benchmark

echo "=== 系统优化完成 ==="
```



***

### **IBM官方资源**

\- **IBM Storage Scale文档**: https://www.ibm.com/docs/en/storage-scale

\- **IBM支持中心**: https://www.ibm.com/support/home/

\- **IBM开发者社区**: https://developer.ibm.com/

\- **IBM Red Books**: https://www.redbooks.ibm.com/

\- **IBM技术博客**: https://www.ibm.com/blogs/systems/

***
