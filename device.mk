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
    $(LOCAL_PATH)/recovery/root/recovery.fstab:recovery/root/recovery.fstab

# Also stage init.recovery.mt6789.rc under the *main* root (TARGET_ROOT_OUT),
# via the "root/<path>" destination prefix. The recovery ramdisk packaging
# rule (recovery_intermediates/ramdisk_files-timestamp in build/make/core/Makefile)
# treats TARGET_ROOT_OUT as its baseline -- it rsyncs that whole directory into
# the recovery ramdisk first, then runs
# `cp $(TARGET_ROOT_OUT)/init.recovery.*.rc $(TARGET_RECOVERY_ROOT_OUT)/`.
# Nothing in this tree was ever installed under plain "root/" (only under
# "recovery/root/"), so TARGET_ROOT_OUT (out/target/product/vendor_boot/root)
# had no build rule to create it and never got populated -- which is why the
# rsync step failed with "No such file or directory". Giving it this one real
# file is enough for the directory (and the rest of the baseline root fs
# alongside it) to actually get built.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/init.recovery.mt6789.rc:root/init.recovery.mt6789.rc
