# 网络 Bond 配置脚本

用于 HPC 集群节点的网络 Bond 和 InfiniBand 配置自动化工具。

## 脚本列表

| 脚本 | 用途 |
|------|------|
| `network_bond_setup.sh` | 单节点网络配置（本地执行） |
| `batch_network_setup.sh` | 批量节点配置（调度节点执行） |

---

## network_bond_setup.sh

### 功能
- 自动识别 25G/50G 以太网卡（多种命名模式）
- 自动识别 InfiniBand 网卡（多种命名模式）
- 从模板节点复制配置文件并自动修改
- 支持 dry-run 预览模式
- 支持回滚到备份配置

### 使用方法

```bash
# 正常执行（交互式）
./network_bond_setup.sh

# 预览模式（不实际执行）
./network_bond_setup.sh --dry-run

# 自动确认执行
./network_bond_setup.sh --yes

# 回滚到最近备份
./network_bond_setup.sh --rollback

# 回滚到指定备份
./network_bond_setup.sh --rollback /root/nm-backup-20260202_120000

# 指定源节点和网关
./network_bond_setup.sh --source gnode18 --gateway 172.16.8.254

# 查看帮助
./network_bond_setup.sh --help
```

### 配置文件
脚本会修改以下 NetworkManager 配置文件：

| 文件 | 修改内容 |
|------|---------|
| `eth_bond_50g.nmconnection` | Bond IP 地址 |
| `eth_bond_50g-slave1.nmconnection` | 第一块以太网卡名 |
| `eth_bond_50g-slave2.nmconnection` | 第二块以太网卡名 |
| `ib_200g_p1.nmconnection` | IB 网卡名和 IP |

### 执行流程

```
1. 检测网络信息
   ├── Bond IP (从 eth_bond_50g 或 172.16.x.x 网段)
   ├── 以太网卡 (25G/50G 速度 + 智能模式匹配)
   ├── IB 接口 (多种 IB 命名模式)
   └── IB IP (从 IB 接口或 192.168.8.x / 10.0.x.x 网段)

2. 显示配置摘要，确认执行

3. 备份现有配置 → /root/nm-backup-日期/

4. 从源节点复制模板

5. 修改配置文件 (IP、接口名、UUID)

6. 设置权限 (600)

7. 激活连接
   ├── nmcli connection up eth_bond_50g-slave1
   ├── nmcli connection up eth_bond_50g-slave2
   └── nmcli connection up ib_200g_p1

8. 验证配置
```

---

## 支持的网卡命名模式

### 以太网 (Ethernet)

基于 systemd/udev predictable naming 规范：

| 模式 | 示例 | 说明 |
|------|------|------|
| `eno*` | `eno1`, `eno2` | 板载网卡 (BIOS/firmware 编号) |
| `ens*f*` | `ens1f0`, `ens1f1` | 热插拔槽网卡 |
| `enp*s0f*` | `enp5s0f0`, `enp5s0f1` | Intel X710/E810 PCI 网卡 |
| `enp*s0f*np*` | `enp5s0f0np0`, `enp5s0f1np1` | Mellanox ConnectX-4/5/6 |
| `enp*s0f*d*` | `enp8s0f0d1` | Broadcom BCM 网卡 |
| 高位 PCI | `enp195s0f0np0` | 大型服务器 (3位数 PCI 总线) |

### InfiniBand (IB)

| 模式 | 示例 | 说明 |
|------|------|------|
| `ib*` | `ib0`, `ib1` | 传统命名 |
| `ibp*s*` | `ibp71s0`, `ibp72s0` | PCI 位置命名 |
| `ibs*` | `ibs5` | 槽位命名 |
| `mlx5_ib*` | `mlx5_ib0` | Mellanox mlx5 驱动 |

---

## batch_network_setup.sh

### 功能
- 从调度节点批量配置多个计算节点
- 自动检测节点连通性
- 支持并行执行加速
- 独立日志记录

### 使用方法

```bash
# 配置指定节点
./batch_network_setup.sh gnode11 gnode12 gnode13

# 配置节点范围 (gnode11 到 gnode20)
./batch_network_setup.sh --range 11-20

# 预览模式
./batch_network_setup.sh --range 11-20 --dry-run

# 并行配置 (4 个节点同时)
./batch_network_setup.sh --range 11-20 --parallel 4

# 自动确认 (无人值守)
./batch_network_setup.sh --range 11-20 --yes

# 查看帮助
./batch_network_setup.sh --help
```

### 前置条件
1. 在调度节点（如 `hpcschd`）以 root 身份运行
2. 配置脚本 `network_bond_setup.sh` 已放置在 `/root/` 目录
3. 能够 SSH 到目标节点

### 日志位置
```
/root/batch_network_logs/gnode{N}_YYYYMMDD_HHMMSS.log
```

---

## 验证配置

执行完成后，使用以下命令验证：

```bash
# 检查 Bond 状态
cat /proc/net/bonding/eth_bond_50g

# 检查 IP 地址
ip -4 addr show eth_bond_50g
ip -4 addr show ibs5  # 或 ibp71s0 等

# 检查活跃连接
nmcli connection show --active

# 测试网络连通性
ping -c 3 172.16.8.254    # 网关
ping -c 3 192.168.8.75    # 其他节点 IB
```

### 快速验证一行命令

```bash
echo "=== Bond ===" && cat /proc/net/bonding/eth_bond_50g | head -20 && \
echo -e "\n=== IPs ===" && ip -4 addr show eth_bond_50g && \
ip -4 addr show $(ls /sys/class/net | grep ^ib | head -1) && \
echo -e "\n=== Ping ===" && ping -c 1 172.16.8.254 && echo "OK"
```

---

## 回滚操作

如果配置出现问题，可以回滚到备份：

```bash
# 回滚到最近备份
./network_bond_setup.sh --rollback

# 查看可用备份
ls -la /root/nm-backup-*

# 回滚到指定备份
./network_bond_setup.sh --rollback /root/nm-backup-20260202_120000
```

---

## 网络拓扑参考

### 节点网卡配置

| 节点分组 | 25G 以太网卡 | IB 接口 |
|---------|-------------|---------|
| gnode1-4 | `enp5s0f0np0`, `enp5s0f1np1` | `ibp71s0` / `ibp72s0` |
| gnode5-10 | `enp195s0f0np0`, `enp195s0f1np1` | `ibs5` |

### IP 网段

| 网络类型 | 网段 | 网关 |
|---------|------|------|
| Bond (50G) | `172.16.8.x/24` | `172.16.8.254` |
| InfiniBand (200G) | `192.168.8.x/24` | - |

---

## 故障排除

### 常见问题

| 问题 | 解决方案 |
|------|---------|
| SSH 连接失败 | 检查 `/etc/ssh/ssh_known_hosts`，清理旧的 host key |
| 无法识别网卡 | 手动指定：脚本会提示输入 |
| sed 命令失败 | 检查变量是否包含特殊字符 |
| 激活连接失败 | 检查配置文件语法：`cat /etc/NetworkManager/system-connections/*.nmconnection` |

### 调试模式

```bash
# 查看详细执行过程
bash -x ./network_bond_setup.sh --dry-run
```

---

## 更新日志

### v3.2 (2026-02-03)
- 扩展以太网卡检测：支持 Intel X710/E810、Broadcom BCM、高位 PCI 总线
- 扩展 IB 检测：支持 `ib*`, `ibp*s*`, `ibs*`, `mlx5_ib*`
- 支持 25G 和 50G 速率检测
- 改进手动选择时的接口列表显示（含速度和状态）
- 新增 10.0.x.x 网段自动检测

### v3.1 (2026-02-03)
- 修复日志输出污染变量的问题
- 改用全局变量存储检测结果
- sed 使用 `#` 分隔符避免与 IP 中 `/` 冲突

### v3.0 (2026-02-02)
- 添加 dry-run 预览模式
- 添加回滚功能
- 添加自动确认选项
- 创建批量执行脚本

### v2.0 (2026-02-02)
- 精确识别 25G 网卡模式
- 支持多种 IB 接口命名

### v1.0 (2026-02-02)
- 初始版本

