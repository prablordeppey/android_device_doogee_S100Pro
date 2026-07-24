#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#
# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit common TWRP stuff (vendor/omni doesn't exist on the AOSP-based
# twrp-12.1 manifest — that's only in the older OmniROM-based manifest
# for Android <=9).
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from vendor_boot device
$(call inherit-product, device/generic/vendor_boot/device.mk)

PRODUCT_DEVICE := vendor_boot
PRODUCT_NAME := omni_vendor_boot
PRODUCT_BRAND := generic
PRODUCT_MODEL := Generic Device
PRODUCT_MANUFACTURER := generic

PRODUCT_GMS_CLIENTID_BASE := android-generic

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="vext_k6789v1_64-user 12 SP1A.210812.016 1rck61v164bspP28 release-keys"

BUILD_FINGERPRINT := 

