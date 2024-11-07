#!/bin/bash
## ZeroWrt by Zero

# 更换rockchip uboot
rm -rf package/boot/rkbin package/boot/uboot-rockchip package/boot/arm-trusted-firmware-rockchip
git clone https://github.com/sbwml/package_boot_uboot-rockchip package/boot/uboot-rockchip
git clone https://github.com/sbwml/arm-trusted-firmware-rockchip package/boot/arm-trusted-firmware-rockchip

# 
