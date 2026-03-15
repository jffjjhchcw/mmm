#!/bin/bash

# Infinity X 云编译脚本 - OPPO K10 5G (PGJM10)
# 支持 Google Colab / AWS /阿里云/腾讯云

set -e

# 配置变量
DEVICE_CODENAME="pgjm10"
DEVICE_NAME="OPPO K10 5G"
ROM_NAME="Infinity X"
ROM_VERSION="16"
ANDROID_VERSION="16"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 检查系统
check_system() {
    log_info "检查系统环境..."
    
    if [[ "$EUID" -ne 0 ]]; then
        log_warn "建议使用 root 用户运行"
    fi
    
    # 检查磁盘空间
    TOTAL_SPACE=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')
    if [[ $TOTAL_SPACE -lt 300 ]]; then
        log_error "需要至少 300GB 可用空间，当前: ${TOTAL_SPACE}GB"
        exit 1
    fi
    
    log_info "磁盘空间: ${TOTAL_SPACE}GB ✓"
}

# 安装依赖
install_dependencies() {
    log_info "安装构建依赖..."
    
    if command -v apt-get &> /dev/null; then
        apt-get update
        apt-get install -y \
            git wget curl unzip xz-utils zip bc bison build-essential \
            ccache flex g++-multilib gcc-multilib gnupg gperf \
            imagemagick lib32ncurses5-dev lib32readline-dev \
            lib32z1-dev liblz4-tool libncurses5-dev libssl-dev \
            lsof python3 python3-pip openjdk-17-jdk
            
    elif command -v yum &> /dev/null; then
        yum groupinstall -y "Development Tools"
        yum install -y git wget curl unzip xz bc bison \
            gcc gcc-c++ make libncurses-devel python3 java-17-openjdk
    fi
    
    log_info "依赖安装完成 ✓"
}

# 配置 Git
setup_git() {
    log_info "配置 Git..."
    
    git config --global user.name "Infinity-X-Build"
    git config --global user.email "build@infinity-x.com"
    git config --global color.ui auto
    
    log_info "Git 配置完成 ✓"
}

# 安装 Repo 工具
install_repo() {
    log_info "安装 Repo 工具..."
    
    if ! command -v repo &> /dev/null; then
        mkdir -p ~/bin
        curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
        chmod a+x ~/bin/repo
        echo 'export PATH=~/bin:$PATH' >> ~/.bashrc
        export PATH=~/bin:$PATH
    fi
    
    log_info "Repo 安装完成 ✓"
}

# 同步源码
sync_source() {
    log_info "同步 Infinity X 源码..."
    
    mkdir -p ~/android/infinity-x
    cd ~/android/infinity-x
    
    if [[ ! -d ".repo" ]]; then
        repo init --no-repo-verify --git-lfs \
            -u https://github.com/ProjectInfinity-X/manifest.git \
            -b $ROM_VERSION
    fi
    
    log_info "开始同步源码（可能需要 1-4 小时）..."
    repo sync -c -j$(nproc) --force-sync --no-tags --no-clone-bundle
    
    log_info "源码同步完成 ✓"
}

# 配置设备树
setup_device_tree() {
    log_info "配置设备树..."
    
    cd ~/android/infinity-x/device
    
    # 克隆设备树
    if [[ ! -d "oppo/$DEVICE_CODENAME" ]]; then
        mkdir -p oppo/$DEVICE_CODENAME
    fi
    
    # 复制预置的设备树文件
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [[ -d "$SCRIPT_DIR/device_tree/$DEVICE_CODENAME" ]]; then
        cp -r $SCRIPT_DIR/device_tree/$DEVICE_CODENAME/* oppo/$DEVICE_CODENAME/
    fi
    
    log_info "设备树配置完成 ✓"
}

# 配置缓存
setup_ccache() {
    log_info "配置 CCache..."
    
    export USE_CCACHE=1
    export CCACHE_DIR=~/.ccache
    ccache -M 100G
    
    log_info "CCache 配置完成 ✓"
}

# 开始编译
build_rom() {
    log_info "开始编译 Infinity X..."
    
    cd ~/android/infinity-x
    
    export PATH=~/bin:$PATH
    export USE_CCACHE=1
    export CCACHE_DIR=~/.ccache
    
    source build/envsetup.sh
    lunch infinity_${DEVICE_CODENAME}-eng
    
    log_info "编译开始（可能需要 1-3 小时）..."
    mka bacon -j$(nproc)
    
    log_info "编译完成！"
    
    # 显示输出文件
    ls -lh out/target/product/${DEVICE_CODENAME}/*.zip
}

# 主菜单
main() {
    echo "============================================"
    echo "  Infinity X 云编译脚本"
    echo "  设备: $DEVICE_NAME ($DEVICE_CODENAME)"
    echo "  Android: $ANDROID_VERSION"
    echo "============================================"
    echo ""
    
    check_system
    
    echo "请选择操作:"
    echo "1) 全新编译（下载源码 + 编译）"
    echo "2) 仅编译（源码已下载）"
    echo "3) 仅同步源码"
    echo "4) 仅安装依赖"
    echo "5) 退出"
    echo ""
    read -p "请输入选项 [1-5]: " choice
    
    case $choice in
        1)
            install_dependencies
            setup_git
            install_repo
            setup_device_tree
            sync_source
            setup_ccache
            build_rom
            ;;
        2)
            setup_ccache
            build_rom
            ;;
        3)
            sync_source
            ;;
        4)
            install_dependencies
            setup_git
            install_repo
            ;;
        5)
            exit 0
            ;;
        *)
            log_error "无效选项"
            exit 1
            ;;
    esac
}

main "$@"
