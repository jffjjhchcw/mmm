# OPPO K10 5G (PGJM10) - MT6895 Device Tree
# For Infinity X Android 16

## 设备信息
- Model: OPPO K10 5G
- Codename: PGJM10
- SoC: MediaTek MT6895 (Dimensity 8100-MAX)
- RAM: 8GB LPDDR5
- Storage: 128GB/256GB UFS

## 文件说明

需要从官方固件提取以下文件:
1. vendor/ 目录下的所有文件
2. boot.img 中的内核
3. dtbo.img
4. persist 分区

## 使用方法

1. 下载官方固件
2. 使用 extract-files.sh 提取 vendor blobs
3. 修改 BoardConfig.mk 中的分区大小
4. 运行编译

## 参考
- 内核源码: https://github.com/oppo-source/android_kernel_oppo_mt6895
- 通用设备树: https://github.com/wbs306/device_xiaomi_mt6895-common
