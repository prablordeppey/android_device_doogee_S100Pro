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

# NOTE: PRODUCT_DEVICE/PRODUCT_NAME are intentionally left as vendor_boot /
# omni_vendor_boot -- Android.mk gates on `ifeq ($(TARGET_DEVICE),vendor_boot)`
# and the CI workflow lunches "omni_vendor_boot-eng", so renaming these two
# would require updating both of those in lockstep. Only the descriptive
# identity strings below (which don't affect build wiring) are corrected.
PRODUCT_DEVICE := vendor_boot
PRODUCT_NAME := omni_vendor_boot
PRODUCT_BRAND := doogee
PRODUCT_MODEL := S100 Pro
PRODUCT_MANUFACTURER := doogee

PRODUCT_GMS_CLIENTID_BASE := android-generic

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="vext_k6789v1_64-user 12 SP1A.210812.016 1rck61v164bspP28 release-keys"

BUILD_FINGERPRINT := 

