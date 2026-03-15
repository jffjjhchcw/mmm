#!/bin/bash
# Setup makefiles for OPPO K10 5G (PGJM10)

DEVICE=pgjm10
VENDOR=oppo

export DEVICE=$DEVICE
export VENDOR=$VENDOR
export TARGET_DEVICE=$DEVICE

echo "Setting up makefiles for $DEVICE..."

DEVICE_MAKEFILE="device/$VENDOR/$DEVICE/pgjm10.mk"
PRODUCT_MAKEFILE="device/$VENDOR/$DEVICE/AndroidProducts.mk"

# Copy to device directory
mkdir -p device/$VENDOR/$DEVICE
cp -r $(dirname $(readlink -f $0))/../device_tree/$DEVICE/* device/$VENDOR/$DEVICE/ 2>/dev/null || true

echo "Makefiles setup complete!"
