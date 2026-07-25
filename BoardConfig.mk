#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/generic/vendor_boot

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := generic

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := vendor_boot
TARGET_NO_BOOTLOADER := true

# Display
TARGET_SCREEN_DENSITY := 480

# Kernel
# AOSP's build system only counts a product as "building a vendor_boot
# image" (sets internal BUILDING_VENDOR_BOOT_IMAGE := true) when it sees
# BOARD_BOOT_HEADER_VERSION >= 3. "BOARD_BOOTIMG_HEADER_VERSION" (the name
# this tree originally had) is not read anywhere in build/make/core -- it's
# a harmless-looking typo that silently left BUILDING_VENDOR_BOOT_IMAGE
# false the entire time, which is why nothing ever actually got built.
# Source: https://android.googlesource.com/platform/build/+/master/core/board_config.mk
BOARD_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

# All values below (base, kernel_offset, ramdisk_offset, tags_offset,
# dtb_offset, pagesize, vendor_cmdline) were read directly out of the
# stock vendor_boot.img header via Android Image Kitchen's split_img
# (vendor_boot.img-base / -kernel_offset / -ramdisk_offset / -tags_offset /
# -dtb_offset / -pagesize / -vendor_cmdline), not guessed.
BOARD_KERNEL_BASE := 0x3fff8000
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2
BOARD_KERNEL_PAGESIZE := 4096
BOARD_RAMDISK_OFFSET := 0x26f08000
BOARD_KERNEL_TAGS_OFFSET := 0x07c88000
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_DTB_OFFSET := 0x07c88000
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
TARGET_FORCE_PREBUILT_KERNEL := true
ifeq ($(TARGET_FORCE_PREBUILT_KERNEL),true)
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img
endif

# TARGET_PREBUILT_DTB (above) is not read by the rule that actually builds
# dtb.img -- that rule only gets a recipe when BOARD_PREBUILT_DTBIMAGE_DIR
# points at a *directory* containing one or more .dtb files, which it then
# concatenates. Without this, dtb.img was a phantom ninja dependency with
# no rule to produce it, then (once fixed to have a rule but no files in
# the dir) an empty file, which mkbootimg rejects with
# "DTB image must not be empty".
# Source: https://android.googlesource.com/platform/build/+/master/core/Makefile
BOARD_PREBUILT_DTBIMAGE_DIR := $(DEVICE_PATH)/prebuilt/dtb

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864

# Confirmed from split_img's vendor_boot.img-origsize (67108864 = 64MiB).
# This is the real value, not a placeholder -- origsize is AIK's name for
# the total size of the source image it split, which is the vendor_boot
# partition size.
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864

BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# Platform
TARGET_BOARD_PLATFORM := mt6789

# Dynamic partitions
# fstab.mt6789/fstab.emmc from the stock vendor_boot ramdisk mark system,
# vendor, product, vendor_dlkm and odm_dlkm as "logical" -- they live
# inside a super partition, not as standalone by-name partitions. Without
# these, TWRP has no way to resolve those mount points via device-mapper.
# TODO: BOARD_SUPER_PARTITION_SIZE is a PLACEHOLDER (matches partition
# size above) -- replace with the real value from
# `fastboot getvar partition-size:super` or `lpdump` before relying on
# this for anything that touches /system, /vendor, or /product.
BOARD_SUPER_PARTITION_SIZE := 240000000
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_PARTITION_LIST := system vendor product vendor_dlkm odm_dlkm
BOARD_SUPER_PARTITION_METADATA_DEVICE := system

# Recovery
# NOTE: header v4 vendor_boot devices don't build a real "recovery" image at
# all -- TWRP has to be packaged as a standalone recovery ramdisk *fragment*
# inside vendor_boot.img instead. Without these three lines, the build
# system has no rule that actually assembles a TWRP ramdisk, which is why
# `mka vendorbootimage` previously produced a plain (non-TWRP) vendor_boot
# image with nothing left to build ("ninja: no work to do").
# Docs: https://source.android.com/docs/core/architecture/partitions/vendor-boot-partitions
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/recovery.fstab
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TW_THEME := portrait_hdpi
TW_EXTRA_LANGUAGES := true
TW_SCREEN_BLANK_ON_BOOT := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_USE_TOOLBOX := true

# Hack: prevent anti rollback
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := 2099-12-31
PLATFORM_VERSION := 16.1.0
