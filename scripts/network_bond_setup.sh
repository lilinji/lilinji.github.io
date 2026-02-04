#!/bin/bash
#
# 网络 Bond 配置脚本 v3.2
# 用途: 在节点上配置 50G bond 和 200G InfiniBand 网络
#
# 功能:
#   - 自动识别网卡和 IP 地址
#   - 支持 dry-run 模式 (预览)
#   - 支持回滚到备份配置
#   - 支持批量执行 (见 batch_network_setup.sh)
#
# 使用方法:
#   ./network_bond_setup.sh              # 正常执行
#   ./network_bond_setup.sh --dry-run    # 预览模式
#   ./network_bond_setup.sh --rollback   # 回滚到最近备份
#   ./network_bond_setup.sh --help       # 帮助
#

set -e

# ==================== 配置变量 ====================
SOURCE_NODE="gnode18"
CONFIG_DIR="/etc/NetworkManager/system-connections"
BACKUP_BASE="/root"
GATEWAY="172.16.8.254"

# 运行模式
DRY_RUN=false
ROLLBACK=false
ROLLBACK_PATH=""
AUTO_CONFIRM=false

# 网络信息 (全局变量)
BOND_IP=""
ETH1=""
ETH2=""
IB_IFACE=""
IB_IP=""
BACKUP_PATH=""

# ==================== 颜色定义 ====================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ==================== 日志函数 (输出到 stderr) ====================
log_info()  { echo -e "${GREEN}[INFO]${NC} $1" >&2; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1" >&2; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
log_step()  { echo -e "${BLUE}[STEP]${NC} $1" >&2; }
log_dry()   { echo -e "${CYAN}[DRY-RUN]${NC} $1" >&2; }

# ==================== 帮助信息 ====================
show_help() {
    cat << EOF
网络 Bond 配置脚本 v3.2

用法: $0 [选项]

选项:
  --dry-run           预览模式，只显示会执行的操作，不实际修改
  --rollback [PATH]   回滚模式，恢复到指定备份或最近的备份
  --yes, -y           自动确认，不提示
  --source NODE       指定配置模板来源节点 (默认: $SOURCE_NODE)
  --gateway IP        指定网关地址 (默认: $GATEWAY)
  --help, -h          显示帮助信息

示例:
  $0                           # 交互式执行
  $0 --dry-run                 # 预览要执行的操作
  $0 --yes                     # 自动确认执行
  $0 --rollback                # 回滚到最近备份
  $0 --rollback /root/nm-backup-20260202_120000  # 回滚到指定备份

备份位置: $BACKUP_BASE/nm-backup-*
EOF
    exit 0
}

# ==================== 参数解析 ====================
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --rollback)
                ROLLBACK=true
                if [[ -n "$2" ]] && [[ ! "$2" =~ ^-- ]]; then
                    ROLLBACK_PATH="$2"
                    shift
                fi
                shift
                ;;
            --yes|-y)
                AUTO_CONFIRM=true
                shift
                ;;
            --source)
                SOURCE_NODE="$2"
                shift 2
                ;;
            --gateway)
                GATEWAY="$2"
                shift 2
                ;;
            --help|-h)
                show_help
                ;;
            *)
                log_error "未知参数: $1"
                show_help
                ;;
        esac
    done
}

# ==================== 工具函数 ====================
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "此脚本必须以 root 身份运行"
        exit 1
    fi
}

confirm() {
    if [[ "$AUTO_CONFIRM" == "true" ]]; then
        return 0
    fi
    read -p "$1 [y/N]: " answer
    [[ "$answer" == "y" || "$answer" == "Y" ]]
}

# ==================== 回滚功能 ====================
do_rollback() {
    log_step "执行回滚操作..."
    
    local backup_dir=""
    
    # 查找备份目录
    if [[ -n "$ROLLBACK_PATH" ]]; then
        if [[ ! -d "$ROLLBACK_PATH" ]]; then
            log_error "指定的备份目录不存在: $ROLLBACK_PATH"
            exit 1
        fi
        backup_dir="$ROLLBACK_PATH"
    else
        # 查找最近的备份
        backup_dir=$(ls -td "$BACKUP_BASE"/nm-backup-* 2>/dev/null | head -1)
        if [[ -z "$backup_dir" ]]; then
            log_error "未找到任何备份目录"
            log_info "备份目录格式: $BACKUP_BASE/nm-backup-*"
            exit 1
        fi
    fi
    
    log_info "将从以下备份恢复:"
    log_info "  $backup_dir"
    echo ""
    log_info "备份内容:"
    ls -la "$backup_dir"
    echo ""
    
    if ! confirm "确认回滚?"; then
        log_info "操作已取消"
        exit 0
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry "将清空 $CONFIG_DIR"
        log_dry "将复制 $backup_dir/* 到 $CONFIG_DIR/"
        log_dry "将执行 chmod 600 $CONFIG_DIR/*.nmconnection"
        log_dry "将执行 nmcli connection reload"
        log_dry "将执行 nmcli connection up eth_bond_50g-slave1"
        log_dry "将执行 nmcli connection up eth_bond_50g-slave2"
        log_dry "将执行 nmcli connection up ib_200g_p1"
    else
        rm -rf "$CONFIG_DIR"/*
        cp -a "$backup_dir"/* "$CONFIG_DIR"/
        chmod 600 "$CONFIG_DIR"/*.nmconnection
        
        log_info "配置文件已恢复"
        
        nmcli connection reload
        sleep 1
        
        log_info "重新激活连接..."
        nmcli connection up eth_bond_50g-slave1 || true
        sleep 1
        nmcli connection up eth_bond_50g-slave2 || true
        sleep 1
        nmcli connection up ib_200g_p1 || true
        
        log_info "✅ 回滚完成!"
    fi
    
    exit 0
}

# ==================== 网络检测函数 ====================
# 注意: 这些函数设置全局变量，不使用 echo 返回值
#
# 支持的网卡命名模式 (基于 systemd/udev predictable naming):
# ==================== 以太网 (Ethernet) ====================
# 格式: en<type><location>
#   类型 (type):  o = 板载, s = 热插拔槽, p = PCI
#   位置 (location): <bus>s<slot>f<function>[n<phys_port>][p<dev_port>][d<dev_id>]
#
# 常见模式:
#   eno1, eno2           - 板载网卡 (BIOS/firmware 编号)
#   ens1f0, ens1f1       - 热插拔槽网卡 (slot=1, function=0/1)
#   enp5s0f0, enp5s0f1   - PCI 网卡 (bus=5, slot=0)
#   enp5s0f0np0          - PCI + 物理端口 (Mellanox ConnectX)
#   enp195s0f0np0        - 高位 PCI 总线 (常见于大型服务器)
#   enp<bus>s0f0np0/enp<bus>s0f1np1 - 双端口卡 bond 对
#
# 厂商/型号:
#   Mellanox ConnectX-4/5/6: enp*s0f0np0, enp*s0f1np1
#   Intel X710/E810:   enp*s0f0, enp*s0f1 或 ens*f0, ens*f1
#   Broadcom BCM:      enp*s0f0d1, enp*s0f1d1
#
# ==================== InfiniBand (IB) ====================
# 常见模式:
#   ib0, ib1             - 传统命名
#   ibp<bus>s<slot>      - PCI 位置 (ibp71s0, ibp72s0)
#   ibs<slot>            - 槽位命名 (ibs5)
#   mlx5_ib0             - 驱动命名 (Mellanox mlx5 driver)
# ===========================================================

detect_bond_ip() {
    log_step "获取当前 bond 接口 IP 地址..."
    
    # 尝试多种 bond 接口名称
    local bond_names=("eth_bond_50g" "bond0" "bond1" "eth_bond")
    for bond in "${bond_names[@]}"; do
        BOND_IP=$(ip -4 addr show "$bond" 2>/dev/null | grep -oP 'inet \K[\d.]+/\d+' | head -1)
        [[ -n "$BOND_IP" ]] && break
    done
    
    if [[ -z "$BOND_IP" ]]; then
        BOND_IP=$(ip -4 addr | grep -oP 'inet \K172\.16\.\d+\.\d+/\d+' | head -1)
    fi
    
    if [[ -z "$BOND_IP" ]]; then
        log_warn "无法自动获取 bond IP 地址"
        read -p "请手动输入 bond IP 地址 (格式: x.x.x.x/xx): " BOND_IP
    fi
    
    log_info "Bond IP: $BOND_IP"
}

detect_eth_interfaces() {
    log_step "识别 25G/50G 以太网卡..."
    
    ETH1=""
    ETH2=""
    
    # 排除项: 虚拟/系统接口
    local exclude_pattern='^(lo|docker|vir|br|veth|virbr|bond|eth_bond|ib|tun|tap|vxlan|wl|ww)'
    
    # ==================== 方法1: 25G/50G 速度 + 智能模式匹配 ====================
    local nics_25g=()
    for nic in $(ls /sys/class/net 2>/dev/null | grep -Ev "$exclude_pattern"); do
        local speed=$(cat /sys/class/net/$nic/speed 2>/dev/null || echo 0)
        # 25G = 25000, 50G = 50000 (部分网卡实际显示 25000)
        if [[ "$speed" == "25000" || "$speed" == "50000" ]]; then
            nics_25g+=("$nic")
        fi
    done
    
    # 从 25G 网卡中识别配对
    for nic in "${nics_25g[@]}"; do
        # Mellanox ConnectX (np0/np1 后缀)
        if [[ "$nic" =~ f0np0$ ]] && [[ -z "$ETH1" ]]; then
            ETH1="$nic"
        elif [[ "$nic" =~ f1np1$ ]] && [[ -z "$ETH2" ]]; then
            ETH2="$nic"
        # Intel/Broadcom (f0/f1 后缀)
        elif [[ "$nic" =~ s0f0$ ]] && [[ -z "$ETH1" ]]; then
            ETH1="$nic"
        elif [[ "$nic" =~ s0f1$ ]] && [[ -z "$ETH2" ]]; then
            ETH2="$nic"
        fi
    done
    
    # ==================== 方法2: 纯模式匹配 (无速度检测时) ====================
    if [[ -z "$ETH1" ]] || [[ -z "$ETH2" ]]; then
        for nic in $(ls /sys/class/net 2>/dev/null | grep -Ev "$exclude_pattern"); do
            # Mellanox ConnectX 双端口: enp<bus>s0f0np0 / enp<bus>s0f1np1
            if [[ "$nic" =~ ^enp[0-9]+s0f0np0$ ]] && [[ -z "$ETH1" ]]; then
                ETH1="$nic"
            elif [[ "$nic" =~ ^enp[0-9]+s0f1np1$ ]] && [[ -z "$ETH2" ]]; then
                ETH2="$nic"
            # Intel X710/E810 双端口: enp<bus>s0f0 / enp<bus>s0f1
            elif [[ "$nic" =~ ^enp[0-9]+s0f0$ ]] && [[ -z "$ETH1" ]]; then
                ETH1="$nic"
            elif [[ "$nic" =~ ^enp[0-9]+s0f1$ ]] && [[ -z "$ETH2" ]]; then
                ETH2="$nic"
            # 热插拔槽: ens<slot>f0 / ens<slot>f1
            elif [[ "$nic" =~ ^ens[0-9]+f0(np[0-9]+)?$ ]] && [[ -z "$ETH1" ]]; then
                ETH1="$nic"
            elif [[ "$nic" =~ ^ens[0-9]+f1(np[0-9]+)?$ ]] && [[ -z "$ETH2" ]]; then
                ETH2="$nic"
            fi
        done
    fi
    
    # ==================== 方法3: 高位 PCI 总线 (大型服务器) ====================
    if [[ -z "$ETH1" ]] || [[ -z "$ETH2" ]]; then
        for nic in $(ls /sys/class/net 2>/dev/null | grep -Ev "$exclude_pattern"); do
            # 3位数 PCI 总线号: enp195s0f0np0 等
            if [[ "$nic" =~ ^enp[0-9]{2,3}s0f0np0$ ]] && [[ -z "$ETH1" ]]; then
                ETH1="$nic"
            elif [[ "$nic" =~ ^enp[0-9]{2,3}s0f1np1$ ]] && [[ -z "$ETH2" ]]; then
                ETH2="$nic"
            elif [[ "$nic" =~ ^enp[0-9]{2,3}s0f0$ ]] && [[ -z "$ETH1" ]]; then
                ETH1="$nic"
            elif [[ "$nic" =~ ^enp[0-9]{2,3}s0f1$ ]] && [[ -z "$ETH2" ]]; then
                ETH2="$nic"
            fi
        done
    fi
    
    # ==================== 方法4: 通用模式 (d1 设备端口后缀) ====================
    if [[ -z "$ETH1" ]] || [[ -z "$ETH2" ]]; then
        for nic in $(ls /sys/class/net 2>/dev/null | grep -Ev "$exclude_pattern"); do
            # Broadcom: enp*s0f0d1 / enp*s0f1d1
            if [[ "$nic" =~ ^enp[0-9]+s0f0d[0-9]+$ ]] && [[ -z "$ETH1" ]]; then
                ETH1="$nic"
            elif [[ "$nic" =~ ^enp[0-9]+s0f1d[0-9]+$ ]] && [[ -z "$ETH2" ]]; then
                ETH2="$nic"
            fi
        done
    fi
    
    # ==================== 手动选择 ====================
    if [[ -z "$ETH1" ]] || [[ -z "$ETH2" ]]; then
        log_warn "无法自动识别两块以太网卡"
        log_info "可用网络接口:"
        echo "" >&2
        printf "  %-25s %-10s %-10s\n" "接口" "速度(Mb)" "状态" >&2
        printf "  %-25s %-10s %-10s\n" "---" "---" "---" >&2
        for nic in $(ls /sys/class/net 2>/dev/null | grep -Ev "$exclude_pattern"); do
            local speed=$(cat /sys/class/net/$nic/speed 2>/dev/null || echo "NA")
            local state=$(cat /sys/class/net/$nic/operstate 2>/dev/null || echo "unknown")
            printf "  %-25s %-10s %-10s\n" "$nic" "$speed" "$state" >&2
        done
        echo "" >&2
        read -p "请输入第一块网卡 (Slave1): " ETH1
        read -p "请输入第二块网卡 (Slave2): " ETH2
    fi
    
    log_info "Eth1: $ETH1"
    log_info "Eth2: $ETH2"
}

detect_ib_interface() {
    log_step "识别 InfiniBand 网卡..."
    
    IB_IFACE=""
    
    # 排除项
    local exclude_pattern='^(lo|docker|vir|br|bond|eth_bond|en|em|eth)'
    
    # ==================== 方法1: 标准 IB 命名 ====================
    # ib0, ib1 等传统命名
    for nic in $(ls /sys/class/net 2>/dev/null | grep -E '^ib[0-9]+$'); do
        IB_IFACE="$nic"
        break
    done
    
    # ==================== 方法2: PCI 位置命名 ====================
    # ibp<bus>s<slot> (例: ibp71s0, ibp72s0)
    if [[ -z "$IB_IFACE" ]]; then
        for nic in $(ls /sys/class/net 2>/dev/null | grep -E '^ibp[0-9]+s[0-9]+$'); do
            IB_IFACE="$nic"
            break
        done
    fi
    
    # ==================== 方法3: 槽位命名 ====================
    # ibs<slot> (例: ibs5)
    if [[ -z "$IB_IFACE" ]]; then
        for nic in $(ls /sys/class/net 2>/dev/null | grep -E '^ibs[0-9]+$'); do
            IB_IFACE="$nic"
            break
        done
    fi
    
    # ==================== 方法4: 任何 ib 前缀 ====================
    if [[ -z "$IB_IFACE" ]]; then
        IB_IFACE=$(ls /sys/class/net 2>/dev/null | grep -E '^ib' | head -1)
    fi
    
    # ==================== 方法5: Mellanox mlx5 驱动命名 ====================
    if [[ -z "$IB_IFACE" ]]; then
        IB_IFACE=$(ls /sys/class/net 2>/dev/null | grep -E '^mlx5_ib' | head -1)
    fi
    
    # ==================== 手动选择 ====================
    if [[ -z "$IB_IFACE" ]]; then
        log_warn "无法自动识别 InfiniBand 网卡"
        log_info "可用网络接口:"
        echo "" >&2
        for nic in $(ls /sys/class/net 2>/dev/null | grep -Ev "$exclude_pattern"); do
            local state=$(cat /sys/class/net/$nic/operstate 2>/dev/null || echo "unknown")
            echo "  - $nic ($state)" >&2
        done
        echo "" >&2
        read -p "请输入 IB 网卡名称: " IB_IFACE
    fi
    
    log_info "IB 接口: $IB_IFACE"
}

detect_ib_ip() {
    log_step "获取 IB IP 地址..."
    
    IB_IP=$(ip -4 addr show "$IB_IFACE" 2>/dev/null | grep -oP 'inet \K[\d.]+/\d+' | head -1)
    
    # 尝试 192.168.8.x 网段
    if [[ -z "$IB_IP" ]]; then
        IB_IP=$(ip -4 addr | grep -oP 'inet \K192\.168\.8\.\d+/\d+' | head -1)
    fi
    
    # 尝试 10.0.x.x 网段 (某些集群使用)
    if [[ -z "$IB_IP" ]]; then
        IB_IP=$(ip -4 addr | grep -oP 'inet \K10\.0\.\d+\.\d+/\d+' | head -1)
    fi
    
    if [[ -z "$IB_IP" ]]; then
        log_warn "无法自动获取 IB IP 地址"
        read -p "请输入 IB IP (格式: x.x.x.x/xx): " IB_IP
    fi
    
    log_info "IB IP: $IB_IP"
}

# ==================== 配置操作函数 ====================
backup_and_clean() {
    log_step "备份并清理现有配置..."
    
    BACKUP_PATH="$BACKUP_BASE/nm-backup-$(date +%Y%m%d_%H%M%S)"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        if [[ -d "$CONFIG_DIR" ]] && [[ -n "$(ls -A $CONFIG_DIR 2>/dev/null)" ]]; then
            log_dry "将备份到: $BACKUP_PATH"
        fi
        log_dry "将清空: $CONFIG_DIR"
    else
        if [[ -d "$CONFIG_DIR" ]] && [[ -n "$(ls -A $CONFIG_DIR 2>/dev/null)" ]]; then
            mkdir -p "$BACKUP_PATH"
            cp -a "$CONFIG_DIR"/* "$BACKUP_PATH"/ 2>/dev/null || true
            log_info "已备份到: $BACKUP_PATH"
        fi
        rm -rf "$CONFIG_DIR"/*
        log_info "已清理 $CONFIG_DIR"
    fi
}

copy_templates() {
    log_step "从 $SOURCE_NODE 复制配置模板..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry "将执行: scp $SOURCE_NODE:$CONFIG_DIR/* $CONFIG_DIR/"
    else
        cd "$CONFIG_DIR"
        if ! scp "$SOURCE_NODE:$CONFIG_DIR/"* . 2>/dev/null; then
            log_error "无法从 $SOURCE_NODE 复制配置文件"
            exit 1
        fi
        log_info "已复制配置文件:"
        ls *.nmconnection 2>/dev/null || ls -la
    fi
}

modify_bond_config() {
    local config_file="$CONFIG_DIR/eth_bond_50g.nmconnection"
    
    log_step "修改 Bond 配置..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry "将修改 $config_file:"
        log_dry "  - address1=${BOND_IP},${GATEWAY}"
        log_dry "  - uuid=<新生成>"
    else
        if [[ ! -f "$config_file" ]]; then
            log_error "配置文件不存在: $config_file"
            exit 1
        fi
        
        # 使用 # 作为 sed 分隔符，避免与 IP 中的 / 冲突
        sed -i "s#^address1=.*#address1=${BOND_IP},${GATEWAY}#" "$config_file"
        sed -i "s#^uuid=.*#uuid=$(uuidgen)#" "$config_file"
        log_info "Bond 配置已更新"
    fi
}

modify_slave_config() {
    local slave_num="$1"
    local interface="$2"
    local config_file="$CONFIG_DIR/eth_bond_50g-slave${slave_num}.nmconnection"
    
    log_step "修改 Slave${slave_num} 配置..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry "将修改 $config_file:"
        log_dry "  - interface-name=${interface}"
        log_dry "  - uuid=<新生成>"
    else
        if [[ ! -f "$config_file" ]]; then
            log_error "配置文件不存在: $config_file"
            exit 1
        fi
        sed -i "s#^interface-name=.*#interface-name=${interface}#" "$config_file"
        sed -i "s#^uuid=.*#uuid=$(uuidgen)#" "$config_file"
        log_info "Slave${slave_num} 接口: $interface"
    fi
}

modify_ib_config() {
    local config_file="$CONFIG_DIR/ib_200g_p1.nmconnection"
    
    log_step "修改 IB 配置..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry "将修改 $config_file:"
        log_dry "  - interface-name=${IB_IFACE}"
        log_dry "  - address1=${IB_IP}"
        log_dry "  - uuid=<新生成>"
    else
        if [[ ! -f "$config_file" ]]; then
            log_error "配置文件不存在: $config_file"
            exit 1
        fi
        
        sed -i "s#^interface-name=.*#interface-name=${IB_IFACE}#" "$config_file"
        
        # 处理 address1 (可能紧跟 may-fail)
        if grep -q "^address1=.*may-fail" "$config_file"; then
            sed -i "s#^address1=.*may-fail#address1=${IB_IP}\nmay-fail#" "$config_file"
        else
            sed -i "s#^address1=.*#address1=${IB_IP}#" "$config_file"
        fi
        
        sed -i "s#^uuid=.*#uuid=$(uuidgen)#" "$config_file"
        log_info "IB 配置已更新"
    fi
}

set_permissions() {
    log_step "设置文件权限..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry "将执行: chmod 600 $CONFIG_DIR/*.nmconnection"
    else
        chmod 600 "$CONFIG_DIR"/*.nmconnection
        log_info "权限已设置为 600"
    fi
}

reload_and_activate() {
    log_step "重新加载并激活连接..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry "将执行: nmcli connection reload"
        log_dry "将执行: nmcli connection up eth_bond_50g-slave1"
        log_dry "将执行: nmcli connection up eth_bond_50g-slave2"
        log_dry "将执行: nmcli connection up ib_200g_p1"
    else
        nmcli connection reload
        sleep 1
        
        log_info "激活 eth_bond_50g-slave1..."
        nmcli connection up eth_bond_50g-slave1 || log_warn "激活 slave1 失败"
        sleep 2
        
        log_info "激活 eth_bond_50g-slave2..."
        nmcli connection up eth_bond_50g-slave2 || log_warn "激活 slave2 失败"
        sleep 2
        
        log_info "激活 ib_200g_p1..."
        nmcli connection up ib_200g_p1 || log_warn "激活 IB 失败"
    fi
}

verify_config() {
    if [[ "$DRY_RUN" == "true" ]]; then
        return
    fi
    
    log_step "验证网络配置..."
    echo ""
    
    echo "=== Bond 状态 ==="
    cat /proc/net/bonding/eth_bond_50g 2>/dev/null | head -20 || log_warn "无法读取 bond"
    
    echo ""
    echo "=== IP 地址 ==="
    ip -4 addr show eth_bond_50g 2>/dev/null || true
    ip -4 addr show "$IB_IFACE" 2>/dev/null || true
    
    echo ""
    echo "=== 活跃连接 ==="
    nmcli connection show --active
}

# ==================== 显示摘要 ====================
show_summary() {
    local mode_text="正常执行"
    [[ "$DRY_RUN" == "true" ]] && mode_text="预览模式 (DRY-RUN)"
    
    echo ""
    echo "╔══════════════════════════════════════════════════╗"
    echo "║           网络配置摘要                           ║"
    echo "╠══════════════════════════════════════════════════╣"
    printf "║  模式:       %-35s ║\n" "$mode_text"
    printf "║  源节点:     %-35s ║\n" "$SOURCE_NODE"
    printf "║  网关:       %-35s ║\n" "$GATEWAY"
    echo "╠══════════════════════════════════════════════════╣"
    printf "║  Bond IP:    %-35s ║\n" "$BOND_IP"
    printf "║  Slave1:     %-35s ║\n" "$ETH1"
    printf "║  Slave2:     %-35s ║\n" "$ETH2"
    printf "║  IB 接口:    %-35s ║\n" "$IB_IFACE"
    printf "║  IB IP:      %-35s ║\n" "$IB_IP"
    echo "╚══════════════════════════════════════════════════╝"
    echo ""
}

# ==================== 主函数 ====================
main() {
    parse_args "$@"
    
    echo ""
    echo "╔══════════════════════════════════════════════════╗"
    echo "║       网络 Bond 配置脚本 v3.1                    ║"
    echo "║       $(date '+%Y-%m-%d %H:%M:%S')                          ║"
    echo "╚══════════════════════════════════════════════════╝"
    
    check_root
    
    # 回滚模式
    if [[ "$ROLLBACK" == "true" ]]; then
        do_rollback
    fi
    
    # 收集网络信息 (设置全局变量)
    detect_bond_ip
    detect_eth_interfaces
    detect_ib_interface
    detect_ib_ip
    
    # 显示摘要
    show_summary
    
    # 确认
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "这是预览模式，不会实际执行任何更改"
        echo ""
    fi
    
    if ! confirm "是否继续?"; then
        log_info "操作已取消"
        exit 0
    fi
    
    # 执行配置
    backup_and_clean
    copy_templates
    modify_bond_config
    modify_slave_config 1 "$ETH1"
    modify_slave_config 2 "$ETH2"
    modify_ib_config
    set_permissions
    reload_and_activate
    verify_config
    
    echo ""
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "✅ 预览完成! 使用不带 --dry-run 的命令实际执行"
    else
        log_info "✅ 配置完成!"
        log_info "📁 备份位于: $BACKUP_PATH"
        log_info "💡 如需回滚: $0 --rollback"
    fi
    echo ""
}

main "$@"
