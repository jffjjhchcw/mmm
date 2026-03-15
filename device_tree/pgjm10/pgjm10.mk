# Device configuration for OPPO K10 5G (PGJM10)
# Infinity X Android 16

PRODUCT_DEVICE := pgjm10
PRODUCT_NAME := infinity_pgjm10
PRODUCT_BRAND := OPPO
PRODUCT_MODEL := OPPO K10 5G
PRODUCT_MANUFACTURER := OPPO
PRODUCT_PLATFORM := mt6895

# Build info
PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE=pgjm10 \
    PRODUCT_DEVICE=pgjm10 \
    BUILD_FINGERPRINT=OPPO/PGJM10/PGJM10:13/SP1A.210812.016/1679042500:user/release-keys \
    PRIVATE_BUILD_DESC="pgjm10-user 13 SP1A.210812.016 1679042500 release-keys"

# A/B partition
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-service

# System properties
PRODUCT_SYSTEM_PROPERTY_OVERRIDES += \
    ro.product.first_api_level=33 \
    ro.product.version.sdk=33

# VNDK
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/vndk/vndk.txt:$(TARGET_COPY_OUT_VENDOR)/etc/vndk.txt

# Include common MT6895 configurations
$(call inherit-product, device/xiaomi_mt6895-common/mt6895-common.mk)
