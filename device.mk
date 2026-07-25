#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#
LOCAL_PATH := device/generic/vendor_boot

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# Copy the recovery-only init scripts into the recovery ramdisk root.
# The "recovery/root/<path>" destination prefix is what tells the AOSP
# build system to stage these under TARGET_RECOVERY_ROOT_OUT instead of
# the normal system/vendor partitions -- previously these three files
# sat in the tree unreferenced by any makefile and never made it into
# the built image at all.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/init.recovery.mt6789.rc:recovery/root/init.recovery.mt6789.rc \
    $(LOCAL_PATH)/recovery/root/mtk-plpath-utils.rc:recovery/root/mtk-plpath-utils.rc \
    $(LOCAL_PATH)/recovery/root/snapuserd.rc:recovery/root/snapuserd.rc


