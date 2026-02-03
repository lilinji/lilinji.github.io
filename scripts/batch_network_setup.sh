#!/bin/bash
#
# 批量网络配置脚本
# 用途: 从调度节点批量配置多个计算节点的网络
#
# 使用方法:
#   ./batch_network_setup.sh gnode11 gnode12 gnode13     # 配置指定节点
#   ./batch_network_setup.sh --range 11-20              # 配置 gnode11 到 gnode20
#   ./batch_network_setup.sh --range 11-20 --dry-run    # 预览模式
#   ./batch_network_setup.sh --range 11-20 --parallel 4 # 并行执行 (4 个节点同时)
#

set -e

# ==================== 配置 ====================
SCRIPT_NAME="network_bond_setup.sh"
SCRIPT_PATH="/root/$SCRIPT_NAME"
NODE_PREFIX="gnode"
LOG_DIR="/root/batch_network_logs"
PARALLEL_JOBS=1

# 运行选项
DRY_RUN=false
AUTO_YES=false
NODES=()

# ==================== 颜色 ====================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step()  { echo -e "${BLUE}[BATCH]${NC} $1"; }

# ==================== 帮助 ====================
show_help() {
    cat << EOF
批量网络配置脚本

用法: $0 [选项] [节点列表...]

选项:
  --range START-END   指定节点范围，如 11-20 表示 gnode11 到 gnode20
  --prefix NAME       节点名前缀 (默认: gnode)
  --parallel N        并行执行的节点数 (默认: 1，串行执行)
  --dry-run           预览模式
  --yes, -y           自动确认
  --script PATH       指定配置脚本路径 (默认: $SCRIPT_PATH)
  --help, -h          显示帮助

示例:
  $0 gnode11 gnode12 gnode13      # 配置指定节点
  $0 --range 11-20                 # 配置 gnode11 到 gnode20
  $0 --range 11-20 --dry-run       # 预览模式
  $0 --range 11-20 --parallel 4    # 4 个节点并行配置
  $0 --range 11-20 --yes           # 自动确认

注意:
  1. 需要在调度节点 (如 hpcschd) 上以 root 身份运行
  2. 需要能够 SSH 到目标节点
  3. 配置脚本 ($SCRIPT_NAME) 需要先上传到本地 $SCRIPT_PATH
EOF
    exit 0
}

# ==================== 参数解析 ====================
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --range)
                local range="$2"
                local start=${range%-*}
                local end=${range#*-}
                for i in $(seq $start $end); do
                    NODES+=("${NODE_PREFIX}${i}")
                done
                shift 2
                ;;
            --prefix)
                NODE_PREFIX="$2"
                shift 2
                ;;
            --parallel)
                PARALLEL_JOBS="$2"
                shift 2
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --yes|-y)
                AUTO_YES=true
                shift
                ;;
            --script)
                SCRIPT_PATH="$2"
                shift 2
                ;;
            --help|-h)
                show_help
                ;;
            -*)
                log_error "未知选项: $1"
                show_help
                ;;
            *)
                NODES+=("$1")
                shift
                ;;
        esac
    done
    
    if [[ ${#NODES[@]} -eq 0 ]]; then
        log_error "未指定任何节点"
        show_help
    fi
}

# ==================== 检查 ====================
check_prerequisites() {
    log_step "检查前置条件..."
    
    # 检查 root
    if [[ $EUID -ne 0 ]]; then
        log_error "此脚本必须以 root 身份运行"
        exit 1
    fi
    
    # 检查配置脚本
    if [[ ! -f "$SCRIPT_PATH" ]]; then
        log_error "配置脚本不存在: $SCRIPT_PATH"
        log_info "请先将 $SCRIPT_NAME 上传到 $SCRIPT_PATH"
        exit 1
    fi
    
    # 创建日志目录
    mkdir -p "$LOG_DIR"
    
    log_info "配置脚本: $SCRIPT_PATH"
    log_info "日志目录: $LOG_DIR"
}

# ==================== 测试连接 ====================
test_connectivity() {
    log_step "测试节点连通性..."
    
    local failed_nodes=()
    
    for node in "${NODES[@]}"; do
        if ssh -o ConnectTimeout=5 -o BatchMode=yes "$node" "echo ok" &>/dev/null; then
            echo -e "  ${GREEN}✓${NC} $node"
        else
            echo -e "  ${RED}✗${NC} $node"
            failed_nodes+=("$node")
        fi
    done
    
    if [[ ${#failed_nodes[@]} -gt 0 ]]; then
        log_warn "以下节点无法连接: ${failed_nodes[*]}"
        if [[ "$AUTO_YES" != "true" ]]; then
            read -p "是否跳过这些节点继续? [y/N]: " answer
            if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
                log_info "操作已取消"
                exit 0
            fi
        fi
        
        # 从列表中移除失败节点
        local new_nodes=()
        for node in "${NODES[@]}"; do
            local skip=false
            for failed in "${failed_nodes[@]}"; do
                [[ "$node" == "$failed" ]] && skip=true
            done
            [[ "$skip" == "false" ]] && new_nodes+=("$node")
        done
        NODES=("${new_nodes[@]}")
    fi
}

# ==================== 配置单个节点 ====================
configure_node() {
    local node="$1"
    local log_file="$LOG_DIR/${node}_$(date +%Y%m%d_%H%M%S).log"
    local extra_args=""
    
    [[ "$DRY_RUN" == "true" ]] && extra_args="--dry-run"
    [[ "$AUTO_YES" == "true" ]] && extra_args="$extra_args --yes"
    
    log_step "配置节点: $node"
    log_info "日志: $log_file"
    
    # 上传脚本并执行
    if ssh "$node" "test -f /root/$SCRIPT_NAME" 2>/dev/null; then
        # 脚本已存在，先删除
        ssh "$node" "rm -f /root/$SCRIPT_NAME"
    fi
    
    # 上传最新脚本
    scp "$SCRIPT_PATH" "$node:/root/$SCRIPT_NAME" &>/dev/null
    
    # 执行脚本
    if ssh "$node" "chmod +x /root/$SCRIPT_NAME && /root/$SCRIPT_NAME $extra_args" 2>&1 | tee "$log_file"; then
        log_info "✅ $node 配置成功"
        return 0
    else
        log_error "❌ $node 配置失败"
        return 1
    fi
}

# ==================== 批量执行 ====================
run_batch() {
    local success_count=0
    local fail_count=0
    local failed_nodes=()
    
    log_step "开始批量配置 ${#NODES[@]} 个节点..."
    echo ""
    
    if [[ $PARALLEL_JOBS -gt 1 ]]; then
        log_info "并行模式: 同时配置 $PARALLEL_JOBS 个节点"
        
        # 使用 GNU parallel 或简单的后台任务
        local pids=()
        local running=0
        
        for node in "${NODES[@]}"; do
            while [[ $running -ge $PARALLEL_JOBS ]]; do
                wait -n 2>/dev/null || true
                running=$((running - 1))
            done
            
            (configure_node "$node") &
            pids+=($!)
            running=$((running + 1))
        done
        
        # 等待所有任务完成
        for pid in "${pids[@]}"; do
            if wait $pid; then
                success_count=$((success_count + 1))
            else
                fail_count=$((fail_count + 1))
            fi
        done
    else
        # 串行执行
        for node in "${NODES[@]}"; do
            echo ""
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            if configure_node "$node"; then
                success_count=$((success_count + 1))
            else
                fail_count=$((fail_count + 1))
                failed_nodes+=("$node")
            fi
        done
    fi
    
    # 汇总报告
    echo ""
    echo "╔══════════════════════════════════════════════════╗"
    echo "║                 批量配置报告                     ║"
    echo "╠══════════════════════════════════════════════════╣"
    printf "║  总节点:     %-35s ║\n" "${#NODES[@]}"
    printf "║  成功:       ${GREEN}%-35s${NC} ║\n" "$success_count"
    printf "║  失败:       ${RED}%-35s${NC} ║\n" "$fail_count"
    echo "╠══════════════════════════════════════════════════╣"
    echo "║  日志目录:   $LOG_DIR"
    echo "╚══════════════════════════════════════════════════╝"
    
    if [[ ${#failed_nodes[@]} -gt 0 ]]; then
        log_warn "失败节点: ${failed_nodes[*]}"
    fi
}

# ==================== 显示计划 ====================
show_plan() {
    echo ""
    echo "╔══════════════════════════════════════════════════╗"
    echo "║             批量网络配置计划                     ║"
    echo "╠══════════════════════════════════════════════════╣"
    printf "║  节点数量:   %-35s ║\n" "${#NODES[@]}"
    printf "║  并行数:     %-35s ║\n" "$PARALLEL_JOBS"
    printf "║  预览模式:   %-35s ║\n" "$DRY_RUN"
    printf "║  自动确认:   %-35s ║\n" "$AUTO_YES"
    echo "╠══════════════════════════════════════════════════╣"
    echo "║  目标节点:                                       ║"
    
    local line=""
    local count=0
    for node in "${NODES[@]}"; do
        line="$line$node "
        count=$((count + 1))
        if [[ $count -ge 5 ]]; then
            printf "║    %-44s ║\n" "$line"
            line=""
            count=0
        fi
    done
    if [[ -n "$line" ]]; then
        printf "║    %-44s ║\n" "$line"
    fi
    
    echo "╚══════════════════════════════════════════════════╝"
    echo ""
}

# ==================== 主函数 ====================
main() {
    echo ""
    echo "╔══════════════════════════════════════════════════╗"
    echo "║         批量网络配置脚本                         ║"
    echo "║         $(date '+%Y-%m-%d %H:%M:%S')                        ║"
    echo "╚══════════════════════════════════════════════════╝"
    
    parse_args "$@"
    check_prerequisites
    show_plan
    test_connectivity
    
    if [[ ${#NODES[@]} -eq 0 ]]; then
        log_error "没有可配置的节点"
        exit 1
    fi
    
    if [[ "$AUTO_YES" != "true" ]]; then
        read -p "是否开始配置? [y/N]: " answer
        if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
            log_info "操作已取消"
            exit 0
        fi
    fi
    
    run_batch
}

main "$@"
