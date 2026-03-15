#!/bin/bash
# Extract vendor blobs from official firmware
# For OPPO K10 5G (PGJM10)

DEVICE=pgjm10
VENDOR=oppo

if [[ -z "$1" ]]; then
    echo "用法: ./extract-files.sh <固件目录>"
    echo "示例: ./extract-files.sh /path/to/firmware"
    exit 1
fi

FIRMWARE_DIR=$1
OUTDIR=vendor/$VENDOR/$DEVICE

mkdir -p $OUTDIR

echo "从固件提取 vendor blobs..."

# 从 payload.bin 提取 (如果存在)
if [[ -f "$FIRMWARE_DIR/payload.bin" ]]; then
    echo "检测到 payload.bin，使用 payload-dumper 提取..."
    # 需要先安装 payload-dumper
    # python3 -m payload_dumper --out $OUTDIR $FIRMWARE_DIR/payload.bin
    echo "请手动安装 payload-dumper: pip3 install payload-dumper"
fi

# 从 ota zip 提取
if [[ -f "$FIRMWARE_DIR/*.zip" ]]; then
    echo "从 OTA 包提取..."
    unzip -o "$FIRMWARE_DIR" "vendor/*" -d $OUTDIR/ 2>/dev/null || true
fi

# 常见 vendor 文件位置
for file in \
    "vendor/bin/hw/vendor.mediatek.hardware.audio@7.0-service" \
    "vendor/lib64/hw/audio.primary.mt6895.so" \
    "vendor/lib64/libmtk_mirrorlink_client.so" \
    "vendor/etc/init/android.hardware.audio@7.0-service.rc" \
    "vendor/etc/vintf/manifest/android.hardware.audio@7.0.xml"; do
    if [[ -f "$FIRMWARE_DIR/$file" ]]; then
        mkdir -p "$OUTDIR/$(dirname $file)"
        cp -r "$FIRMWARE_DIR/$file" "$OUTDIR/$file"
    fi
done

echo "提取完成！"
echo "输出目录: $OUTDIR"
