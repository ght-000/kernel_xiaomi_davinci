#!/bin/sh
# Spoof kernel config for /proc/config.gz to pass Android VINTF compatibility checks
in_file="$1"
out_file="$2"

sed \
  -e 's/^CONFIG_SYSVIPC=y\r*$/# CONFIG_SYSVIPC is not set/' \
  -e 's/^CONFIG_SYSVIPC_SYSCTL=y\r*$/# CONFIG_SYSVIPC_SYSCTL is not set/' \
  -e 's/^CONFIG_SYSVIPC_COMPAT=y\r*$/# CONFIG_SYSVIPC_COMPAT is not set/' \
  -e 's/^CONFIG_IP6_NF_NAT=y\r*$/# CONFIG_IP6_NF_NAT is not set/' \
  "$in_file" | gzip -n -f -9 > "$out_file" || (rm -f "$out_file"; exit 1)
