#!/bin/bash
set -e

KERNEL_DTB="$1"
OUTPUT="$2"

if [ -z "$KERNEL_DTB" ] || [ -z "$OUTPUT" ]; then
  echo "Usage: $0 <path_to_Image.gz-dtb> <output_boot.img>"
  exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MKBOOTIMG="${DIR}/mkbootimg/mkbootimg.py"
AVBTOOL="${DIR}/avbtool.py"

TMP_BOOT="/tmp/k20_boot_unsigned.img"

python3 "$MKBOOTIMG" \
  --header_version 1 \
  --kernel "$KERNEL_DTB" \
  --base 0x00000000 \
  --kernel_offset 0x00008000 \
  --ramdisk_offset 0x00000000 \
  --tags_offset 0x00000100 \
  --pagesize 4096 \
  --os_version 11.0.0 \
  --os_patch_level 2021-10 \
  --cmdline "console=ttyMSM0,115200n8 androidboot.hardware=qcom androidboot.console=ttyMSM0 androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator.enable=1 swiotlb=1 androidboot.usbcontroller=a600000.dwc3 earlycon=msm_geni_serial,0x880000 loop.max_part=7 printk.devkmsg=on buildvariant=user" \
  --output "$TMP_BOOT"

python3 "$AVBTOOL" add_hash_footer \
  --image "$TMP_BOOT" \
  --partition_size 134217728 \
  --partition_name boot \
  --algorithm NONE \
  --prop com.android.build.boot.fingerprint:Xiaomi/davinci/davinci:11/RKQ1.200826.002/V12.5.2.0.RFJCNXM:user/release-keys \
  --prop com.android.build.boot.os_version:11 \
  --prop com.android.build.boot.security_patch:2021-10-01

mv "$TMP_BOOT" "$OUTPUT"
echo "[+] Successfully generated signed boot image: $OUTPUT"
