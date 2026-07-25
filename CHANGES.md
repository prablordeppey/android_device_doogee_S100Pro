# Changes

## Fix: `ninja failed` — `cp: .../recovery/root/system/etc/recovery.fstab: No such file or directory`

**File changed:** `device.mk`

### Root cause
The recovery ramdisk packaging rule (`build/make/core/Makefile`,
`recovery_intermediates/ramdisk_files-timestamp`) works in two steps:
1. `rsync` the baseline root (`TARGET_ROOT_OUT`, i.e.
   `out/target/product/vendor_boot/root`) into the recovery ramdisk.
2. `cp -f $(TARGET_RECOVERY_FSTAB) $(TARGET_RECOVERY_ROOT_OUT)/system/etc/recovery.fstab`

`device.mk` only ever staged one file into `TARGET_ROOT_OUT`
(`root/init.recovery.mt6789.rc`), so no `system/etc` directory ever
existed in the baseline root. Step 1's rsync therefore never created
`system/etc` in the recovery ramdisk either, and step 2's plain `cp`
(which does not create missing parent directories) failed with
"No such file or directory".

### Fix
Added a second `PRODUCT_COPY_FILES` destination that stages
`recovery.fstab` at `root/system/etc/recovery.fstab` (in addition to
the existing `recovery/root/recovery.fstab` destination). Because
`PRODUCT_COPY_FILES` creates parent directories automatically, this
guarantees `system/etc` exists in the baseline root before the
packaging rule's rsync runs — so it survives into the recovery
ramdisk, and the final `cp -f` succeeds (just overwriting the file
with identical content).
