# Infinity X 移植指南 - OPPO K10 5G (PGJM10)

## 设备信息
- **型号**: OPPO K10 5G (PGJM10)
- **处理器**: MT6895 (Dimensity 8100-MAX)
- **内核源码**: https://github.com/oppo-source/android_kernel_oppo_mt6895
- **参考设备树**: https://github.com/wbs306/device_xiaomi_mt6895-common

---

## 关键资源汇总

| 资源 | 链接 |
|------|------|
| Infinity X 源码 | https://github.com/ProjectInfinity-X/manifest |
| OPPO 内核源码 | https://github.com/oppo-source/android_kernel_oppo_mt6895 |
| MT6895 通用设备树 | https://github.com/wbs306/device_xiaomi_mt6895-common |
| 官方固件下载 | https://en.flash-file.net/oppo-k10-5g-pgjm10/ |

---

## 第一步：准备构建环境

### 安装 Ubuntu 22.04+ (推荐)

```bash
# 安装基础依赖
sudo apt update && sudo apt upgrade -y
sudo apt install -y git wget curl unzip xz-utils zip bc bison build-essential ccache curl flex g++-multilib gcc-multilib gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libssl-dev lsof python3 python3-pip

# 安装 OpenJDK 17
sudo apt install -y openjdk-17-jdk
```

### 配置 Git
```bash
git config --global user.name "YourName"
git config --global user.email "your@email.com"
```

### 安装 Repo 工具
```bash
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
echo 'export PATH=~/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

---

## 第二步：克隆 Infinity X 源码

```bash
mkdir -p ~/android/infinity-x
cd ~/android/infinity-x

# 初始化仓库 (Android 16)
repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest.git -b 16

# 同步源码 (需要 2-4 小时)
repo sync -c -j$(nproc) --force-sync --no-tags --no-clone-bundle
```

---

## 第三步：创建设备树

### 方法一：克隆并修改现有设备树（推荐）

```bash
# 进入设备目录
cd ~/android/infinity-x/device

# 克隆 MT6895 通用设备树作为基础
git clone https://github.com/wbs306/device_xiaomi_mt6895-common.git -b 13.0 device_oppo_pgjm10

cd device_oppo_pgjm10

# 重命名文件
mv mt6895-common.mk pgjm10.mk
```

### 创建设备特定文件

1. **AndroidProducts.mk**
```makefile
TARGET_DEVICE := pgjm10
PRODUCT_DEVICE := pgjm10
PRODUCT_NAME := infinity_pgjm10
PRODUCT_BRAND := OPPO
PRODUCT_MODEL := OPPO K10 5G
PRODUCT_MANUFACTURER := OPPO

$(call inherit-product, $(LOCAL_DIR)/pgjm10.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
```

2. **BoardConfig.mk** (修改设备配置)
```makefile
TARGET_BOARD_PLATFORM := mt6895
BOARD_VENDOR := oppo
TARGET_DEVICE := pgjm10
DEVICE_PATH := device/oppo/pgjm10

# 处理器配置
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a78

# 分区大小
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_VENDORIMAGE_PARTITION_SIZE := 2147483648

# 文件系统
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
```

3. **vendorsetup.sh**
```bash
add_lunch_combo infinity_pgjm10-eng
add_lunch_combo infinity_pgjm10-userdebug
```

4. **extract-files.sh** - 从官方固件提取 blobs

---

## 第四步：从官方固件提取 Vendor Blobs

### 方法1: 使用 OTA 固件
```bash
# 下载官方 OTA 固件
# 解压后使用 extract脚本提取
```

### 方法2: 使用现有 TWRP
```bash
# 在手机上安装 TWRP
# 使用 ADB 提取:
adb pull /vendor vendor/
```

---

## 第五步：编译

```bash
cd ~/android/infinity-x

# 设置环境变量
export PATH=~/bin:$PATH
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
ccache -M 100G

# 开始编译
source build/envsetup.sh
lunch infinity_pgjm10-eng
mka bacon -j$(nproc)
```

---

## 第六步：刷入测试

编译完成后，在 `out/target/product/pgjm10/` 目录找到 ROM 包。

### 刷入步骤：
1. 将 ROM 传输到手机
2. 进入 TWRP Recovery
3. Wipe Data/Factory Reset
4. 安装 ROM
5. 重启

---

## 快速开始（推荐）

我已经为你准备好所有文件，位于当前目录：

```
├── cloud_build.sh          # 云编译自动化脚本
├── device_tree/
│   └── pgjm10/             # OPPO K10 5G 设备树
│       ├── AndroidProducts.mk
│       ├── BoardConfig.mk
│       ├── pgjm10.mk
│       ├── vendorsetup.sh
│       ├── extract-files.sh
│       ├── system.prop
│       ├── vendor.prop
│       ├── manifest.xml
│       ├── README.md
│       └── proprietary-files.txt
└── INFINITY_X移植指南.md
```

### 使用方法

#### 方法1：使用 Google Colab（免费）

1. 打开 https://colab.research.google.com
2. 新建笔记本
3. 运行以下命令：

```python
!apt-get update && apt-get install -y git curl unzip xz-utils
!git clone https://github.com/你的用户名/infinity-x-pgjm10.git
%cd infinity-x-pgjm10
!chmod +x cloud_build.sh
!./cloud_build.sh
```

#### 方法2：使用云服务器（推荐）

1. 购买云服务器（推荐配置）：
   - CPU: 8核+
   - RAM: 16GB+
   - 硬盘: 500GB SSD
   - 系统: Ubuntu 22.04

2. 上传文件并运行：
```bash
chmod +x cloud_build.sh
./cloud_build.sh
```

---

## 重要说明

### 需要你完成的事项

1. **提取 Vendor Blobs**
   - 下载官方固件：https://en.flash-file.net/oppo-k10-5g-pgjm10/
   - 使用 `extract-files.sh` 提取
   - 或从 TWRP 中提取：
   ```bash
   adb pull /vendor vendor/
   ```

2. **完善 proprietary-files.txt**
   - 参考：https://github.com/wbs306/device_xiaomi_mt6895-common/blob/13.0/proprietary-files.txt

### 注意事项

1. 首次编译需要下载 ~200GB 源码
2. 编译需要高性能服务器（8核+16G RAM）
3. 整个过程需要 2-6 小时
4. 编译可能遇到错误，需要根据错误信息调试

### 1. 编译错误
- 检查 Java 版本 (需要 JDK 17)
- 确保有足够磁盘空间 (至少 300GB)

### 2. 设备启动失败
- 检查 vendor blobs 是否完整
- 检查内核配置是否正确

### 3. 功能异常
- 可能需要额外移植 Hal 层

---

## 注意事项

1. 首次编译需要 3-8 小时（取决于电脑配置）
2. 需要至少 300GB 硬盘空间
3. 需要 16GB+ RAM
4. OPPO 设备可能需要先解锁 Bootloader
5. 保修会失效
