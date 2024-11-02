#!/bin/bash

# 修改默认IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# Daed大鹅配置
sed -i '$ a\
\
define KernelPackage/xdp-sockets-diag\
  SUBMENU:=$(NETWORK_SUPPORT_MENU)\
  TITLE:=PF_XDP sockets monitoring interface support for ss utility\
  KCONFIG:= \
\tCONFIG_XDP_SOCKETS=y \
\tCONFIG_XDP_SOCKETS_DIAG\
  FILES:=$(LINUX_DIR)/net/xdp/xsk_diag.ko\
  AUTOLOAD:=$(call AutoLoad,31,xsk_diag)\
endef\n\
define KernelPackage/xdp-sockets-diag/description\
 Support for PF_XDP sockets monitoring interface used by the ss tool\
endef\n\
$(eval $(call KernelPackage,xdp-sockets-diag))' package/kernel/linux/modules/netsupport.mk

# 移除要替换的包
rm -rf feeds/packages/net/smartdns
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/luci/applications/luci-app-smartdns
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/packages/net/{alist,adguardhome,mosdns,xray*,v2ray*,v2ray*,sing*,smartdns}
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/packages/lang/golang

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}
