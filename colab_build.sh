#!/bin/bash
# Infinity X Google Colab 一键编译脚本
# 使用方法见下方说明

echo "============================================"
echo "  Infinity X Colab 编译脚本"
echo "  设备: OPPO K10 5G (PGJM10)"
echo "============================================"

# 检查是否为 Colab 环境
if ! command -v google.colab &> /dev/null; then
    echo "错误: 请在 Google Colab 中运行此脚本"
    exit 1
}

# 安装依赖
echo "[1/7] 安装系统依赖..."
!apt-get update
!apt-get install -y git wget curl unzip xz-utils zip bc bison build-essential ccache flex g++-multilib gcc-multilib gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libssl-dev lsof python3 openjdk-17-jdk

# 配置 Git
echo "[2/7] 配置 Git..."
!git config --global user.name "Infinity-X-Build"
!git config --global user.email "build@infinity-x.com"

# 安装 Repo
echo "[3/7] 安装 Repo 工具..."
!mkdir -p ~/bin
!curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
!chmod a+x ~/bin/repo

# 同步源码
echo "[4/7] 同步 Infinity X 源码（约需 1-3 小时）..."
%cd ~/android
!mkdir -p infinity-x
%cd infinity-x
!repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest.git -b 16
!repo sync -c -j$(nproc) --force-sync --no-tags --no-clone-bundle

# 复制设备树
echo "[5/7] 复制设备树..."
# 注意: 需要先上传 device_tree 到 /content/device_tree
!cp -r /content/device_tree/pgjm10 ~/android/infinity-x/device/oppo/

# 配置缓存
echo "[6/7] 配置编译缓存..."
%cd ~/android/infinity-x
!export PATH=~/bin:$PATH
!export USE_CCACHE=1
!export CCACHE_DIR=~/.ccache
!ccache -M 100G

# 开始编译
echo "[7/7] 开始编译..."
!source build/envsetup.sh
!lunch infinity_pgjm10-eng
!mka bacon -j$(nproc)

echo "编译完成！"
