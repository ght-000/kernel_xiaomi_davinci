# SukiSU-Nova Non-GKI (Linux 4.14+) KPM 移植补丁模块

用于在非 GKI（ARM64，Linux 4.14~4.18 等无 `ARCH_HAS_SYSCALL_WRAPPER` 的内核）上启用 **SukiSU-Nova KPM**。

## 包含文件
* `0001-sukisu-nova-unlock-kpm-nongki.patch`：解锁 `SukiSU-Nova` (`builtin-new`) 的 `5.10+` 门控、修复 4.14 `task_struct.thread_pid` 缺失并补充 `__arm64_sys_truncate` 桥接入口。
* `0002-kpimg-allow-no-syscall-wrapper.patch`：移除 `SukiSU_KernelPatch_patch` 中 `sukisu_kpm_supercall_install` 对 `has_syscall_wrapper` 的拦截。
* `apply.sh`：一键打补丁、编译裸机 `kpimg` 并修补内核 `Image` 的脚本。

## 移植步骤（适用于任意 Non-GKI ARM64 内核）

1. **在内核配置中启用以下选项**：
   ```ini
   CONFIG_KSU=y
   CONFIG_KPM=y
   CONFIG_KALLSYMS=y
   CONFIG_KALLSYMS_ALL=y
   ```
2. **拉取 `SukiSU-Nova` (`builtin-new`) 后，修补 KernelSU 源码**：
   ```bash
   bash patches/sukisu_nova_nongki_kpm/apply.sh patch-ksu KernelSU
   ```
3. **编译未压缩的内核 `Image`**：
   ```bash
   make -j$(nproc) Image
   ```
4. **编译定制 `kpimg` 并注入 `Image`**：
   ```bash
   bash patches/sukisu_nova_nongki_kpm/apply.sh patch-image arch/arm64/boot/Image arch/arm64/boot/Image.kpm
   ```
   然后按目标机型要求压缩（如 `gzip -n -f -9 -c Image.kpm > Image.gz`）并拼接 DTB / 打包 `boot.img`。
