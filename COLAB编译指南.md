# Google Colab 免费编译 Infinity X 指南

## 步骤 1: 上传文件到 Google Drive

1. 创建 Google Drive 文件夹: `InfinityX_PGJM10`
2. 上传以下文件到该文件夹:
   - `device_tree/pgjm10/` 整个文件夹
   - `cloud_build.sh`

## 步骤 2: 打开 Google Colab

1. 打开 https://colab.research.google.com
2. 点击 "新建笔记本"
3. 点击 "Runtime" → "Change runtime type"
4. 选择 "GPU" (如果有) 或 "Highmem" 
5. 点击保存

## 步骤 3: 挂载 Google Drive

```python
from google.colab import drive
drive.mount('/content/drive')

# 进入工作目录
%cd /content/drive/MyDrive/InfinityX_PGJM10
```

## 步骤 4: 安装依赖并同步源码

```bash
# 安装依赖
!apt-get update
!apt-get install -y git wget curl unzip xz-utils zip bc bison build-essential ccache flex g++-multilib gcc-multilib gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libssl-dev lsof python3 openjdk-17-jdk repo

# 配置 Git
!git config --global user.name "Build"
!git config --global user.email "build@test.com"

# 同步源码（约 1-3 小时）
!mkdir -p ~/android/infinity-x
%cd ~/android/infinity-x
!repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest.git -b 16
!repo sync -c -j$(nproc) --force-sync
```

## 步骤 5: 复制设备树

```bash
# 从 Drive 复制设备树
%cd ~/android/infinity-x/device/oppo
!cp -r /content/drive/MyDrive/InfinityX_PGJM10/device_tree/pgjm10 ./
```

## 步骤 6: 编译

```bash
%cd ~/android/infinity-x

# 设置环境
import os
os.environ['PATH'] = '/root/bin:' + os.environ['PATH']
os.environ['USE_CCACHE'] = '1'
os.environ['CCACHE_DIR'] = '~/.ccache'

!ccache -M 100G

# 开始编译（约 2-4 小时）
!source build/envsetup.sh
!lunch infinity_pgjm10-eng
!mka bacon -j$(nproc)
```

## 步骤 7: 下载 ROM

```python
from google.colab import files
import os

os.chdir('/root/android/infinity-x/out/target/product/pgjm10')
for f in os.listdir('.'):
    if f.endswith('.zip'):
        files.download(f)
```

---

## 注意事项

1. **Colab 有使用限制**: 免费版每天约 12 小时，Pro 版更多
2. **需要稳定网络**: 同步源码需要良好网络
3. **可能需要多次尝试**: 如果断连，从上次中断的地方继续

---

## 备选方案: 使用 GitHub Actions

如果 Colab 不稳定，也可以使用 GitHub Actions 免费编译（需要会配置 CI/CD）。

---

## 所需文件

请确保 Google Drive 中有以下文件:
- `device_tree/pgjm10/` - 完整设备树（约 1.6GB）

准备好了告诉我，我帮你检查文件是否完整。
