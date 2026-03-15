# Google Colab Infinity X 编译脚本
# 使用方法：
# 1. 打开 https://colab.research.google.com
# 2. 新建笔记本
# 3. 将此代码复制到单元格中运行

# @title 1. 安装依赖
%%bash
apt-get update
apt-get install -y git wget curl unzip xz-utils zip bc bison build-essential ccache flex g++-multilib gcc-multilib gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libssl-dev lsof python3 openjdk-17-jdk

# @title 2. 配置 Git
%%bash
git config --global user.name "Build"
git config --global user.email "build@test.com"

# @title 3. 安装 Repo
%%bash
mkdir -p ~/bin
curl -sSL https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
import os
os.environ['PATH'] = '/root/bin:' + os.environ.get('PATH', '')

# @title 4. 同步源码 (需要 1-3 小时)
%%bash
mkdir -p ~/android/infinity-x
cd ~/android/infinity-x
repo init --no-repo-verify -u https://github.com/ProjectInfinity-X/manifest.git -b 16
repo sync -c -j8 --no-tags --no-clone-bundle

# @title 5. 复制设备树
# 注意: 请先上传 device_tree 文件夹到 Colab
%%bash
cd ~/android/infinity-x/device/oppo
# 如果从 Google Drive 挂载:
from google.colab import drive
drive.mount('/content/drive')
!cp -r /content/drive/MyDrive/device_tree/pgjm10 ./

# @title 6. 编译 (需要 2-4 小时)
%%bash
cd ~/android/infinity-x
import os
os.environ['USE_CCACHE'] = '1'
os.environ['CCACHE_DIR'] = '~/.ccache'
!ccache -M 100G

!source build/envsetup.sh
!lunch infinity_pgjm10-eng
!mka bacon -j$(nproc)

# @title 7. 下载 ROM
from google.colab import files
import os
os.chdir('/root/android/infinity-x/out/target/product/pgjm10')
for f in os.listdir('.'):
    if f.endswith('.zip'):
        files.download(f)
