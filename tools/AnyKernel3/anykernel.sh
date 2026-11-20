### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers
## Adapted for Redmi K20 (davinci)

### AnyKernel setup
# global properties
properties() { '
kernel.string=Redmi K20 Kernel by ght-000
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=davinci
device.name2=davinciin
device.name3=Redmi K20
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# boot shell variables
BLOCK=/dev/block/bootdevice/by-name/boot;
IS_SLOT_DEVICE=0;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# boot install (SAR / ramdisk-less boot.img)
split_boot;

flash_boot;
## end boot install
