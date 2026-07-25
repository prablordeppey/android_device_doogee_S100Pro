#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit common TWRP stuff
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit device configuration
$(call inherit-product, $(LOCAL_PATH)/device.mk)

# Device identifier
PRODUCT_DEVICE := vendor_boot
PRODUCT_NAME := omni_vendor_boot
PRODUCT_BRAND := doogee
PRODUCT_MODEL := S100 Pro
PRODUCT_MANUFACTURER := doogee