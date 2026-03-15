TARGET_DEVICE := pgjm10
PRODUCT_DEVICE := pgjm10
PRODUCT_NAME := infinity_pgjm10
PRODUCT_BRAND := OPPO
PRODUCT_MODEL := OPPO K10 5G
PRODUCT_MANUFACTURER := OPPO

$(call inherit-product, $(LOCAL_DIR)/pgjm10.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
