#!/bin/bash
## ZeroWrt by Zero

# 更换rockchip uboot
rm -rf package/boot/rkbin package/boot/uboot-rockchip package/boot/arm-trusted-firmware-rockchip
git clone https://github.com/sbwml/package_boot_uboot-rockchip package/boot/uboot-rockchip
git clone https://github.com/sbwml/arm-trusted-firmware-rockchip package/boot/arm-trusted-firmware-rockchip

# 修改 LAN IP
sed -i "s/192.168.1.1/10.0.0.1/g" package/base-files/files/bin/config_generate

# Realtek driver - R8168 & R8125 & R8126 & R8152 & R8101
rm -rf package/kernel/r8168 package/kernel/r8101 package/kernel/r8125 package/kernel/r8126
git clone https://github.com/sbwml/package_kernel_r8168  package/kernel/r8168
git clone https://github.com/sbwml/package_kernel_r8152  package/kernel/r8152
git clone https://github.com/sbwml/package_kernel_r8101  package/kernel/r8101
git clone https://github.com/sbwml/package_kernel_r8125  package/kernel/r8125
git clone https://github.com/sbwml/package_kernel_r8126  package/kernel/r8126


