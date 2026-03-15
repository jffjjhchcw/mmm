# Infinity X for OPPO K10 5G (PGJM10)

<p align="center">
  <img src="https://projectinfinity-x.com/img/logo.png" width="200" alt="Infinity X">
</p>

## 设备信息

| 项目 | 信息 |
|------|------|
| 设备 | OPPO K10 5G |
| 型号 | PGJM10 |
| 处理器 | MediaTek MT6895 (Dimensity 8100-MAX) |
| ROM | Infinity X Android 16 |

## 编译说明

### 方法 1: GitHub Actions

1. Fork 此仓库
2. **需要单独添加 vendor blobs** (因为文件太大):
   - 从 TWRP 提取 vendor 分区
   - 上传到 Google Drive 或其他云存储
   - 修改 workflow 下载 vendor
3. 进入 Actions → Run workflow

### 方法 2: 本地编译

```bash
# 1. 克隆源码
repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest.git -b 16
repo sync -c -j$(nproc)

# 2. 复制设备树
cp -r device_tree/pgjm10 device/oppo/

# 3. 编译
source build/envsetup.sh
lunch infinity_pgjm10-eng
mka bacon
```

## 获取 Vendor Blobs

由于 vendor 文件太大 (1.6GB)，需要单独获取：

1. 从你的手机提取 (推荐):
```bash
adb shell
# 在 TWRP 中
mount vendor
adb pull /vendor ./vendor
```

2. 或者从官方固件提取

## 注意事项

- 此设备树需要完善
- 可能需要根据编译错误调整配置
- 首次编译建议使用高性能服务器

## 致谢

- [Infinity X Team](https://github.com/ProjectInfinity-X)
- [OPPO Source](https://github.com/oppo-source)
- [MT6833-Devs](https://github.com/mt6833-devs)
