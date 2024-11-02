#!/bin/bash

# 修改默认IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 移除要替换的包
rm -rf feeds/packages/net/smartdns
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/luci/applications/luci-app-smartdns
rm -rf feeds/luci/applications/luci-app-alist
rm -rf feeds/packages/net/{alist,adguardhome,xray*,v2ray*,sing*,smartdns}
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

# golong1.23依赖
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

# Mosdns
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# Alist
git clone https://github.com/sbwml/luci-app-alist package/alist

# AdGuardHome
git_sparse_clone master https://github.com/kenzok8/openwrt-packages adguardhome luci-app-adguardhome

# 魔法网络
git clone --depth=1 https://github.com/immortalwrt/homeproxy package/homeproxy
git clone --depth=1 -b master https://github.com/fw876/helloworld package/luci-app-ssr-plus
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash
git_sparse_clone main https://github.com/morytyann/OpenWrt-mihomo luci-app-mihomo mihomo

# Theme主题
git clone --depth=1 https://github.com/oppen321/luci-theme-argon package/luci-theme-argon
git clone --depth=1 https://github.com/oppen321/luci-theme-argon-config package/luci-app-argon-config

# SmartDNS
git clone --depth=1 https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
git clone --depth=1 https://github.com/pymumu/openwrt-smartdns package/smartdns

# Lucky
git clone --depth=1 https://github.com/sirpdboy/luci-app-lucky package/luci-app-lucky

# 在线更新
git clone --depth=1 https://github.com/oppen321/luci-app-gpsysupgrade package/luci-app-gpsysupgrade

# iStore应用商店
git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
git_sparse_clone main https://github.com/linkease/istore luci

# 磁盘管理
git clone --depth=1 https://github.com/lisaac/luci-app-diskman

# luci-app-partexp
git clone --depth=1 https://github.com/sirpdboy/luci-app-partexp package/luci-app-partexp

# ChatGpt Web
git clone --depth=1 https://github.com/sirpdboy/chatgpt-web.git package/luci-app-chatgpt

# 一键配置拨号
git clone --depth=1 https://github.com/sirpdboy/luci-app-netwizard package/luci-app-netwizard

# msd_lite
git clone --depth=1 https://github.com/ximiTech/luci-app-msd_lite package/luci-app-msd_lite
git clone --depth=1 https://github.com/ximiTech/msd_lite package/msd_lite

# DDNS.go
git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go

# Socat端口转发
git_sparse_clone main https://github.com/sirpdboy/sirpdboy-package luci-app-socat

# OAF应用过滤
git clone --depth=1 https://github.com/destan19/OpenAppFilter package/OpenAppFilter

# 实时监控
git clone --depth=1 https://github.com/sirpdboy/luci-app-netdata package/luci-app-netdata

# 自定义设置
cp -f $GITHUB_WORKSPACE/Diy/banner package/base-files/files/etc/banner

#更改主机名
sed -i "s/hostname='.*'/hostname='ZeroWrt'/g" package/base-files/files/bin/config_generate

# 个性化设置
echo -e "\nmsgid \"Control\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "msgstr \"控制\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "\nmsgid \"NAS\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "msgstr \"网络存储\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po

# 修改位置
sed -i 's/services/control/g' package/OpenAppFilter/luci-app-oaf/luasrc/controller/*.lua
sed -i 's/services/control/g' package/OpenAppFilter/luci-app-oaf/luasrc/model/cbi/appfilter/*.lua
sed -i 's/services/control/g' package/OpenAppFilter/luci-app-oaf/luasrc/view/admin_network/*.htm
sed -i 's/services/control/g' package/OpenAppFilter/luci-app-oaf/luasrc/cbi/*.htm
sed -i 's/\("admin"\), *\("netwizard"\)/\1, "system", \2/g' package/luci-app-netwizard/luasrc/controller/*.lua

# 取消主题默认设置
find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;

# 在线更新配置
echo -n "$(date +'%Y%m%d')" > package/base-files/files/etc/openwrt_version
sed -i 's/Variable1 = "*.*"/Variable1 = "oppen321"/g' package/luci-app-gpsysupgrade/luasrc/model/cbi/gpsysupgrade/sysupgrade.lua
sed -i 's/Variable2 = "*.*"/Variable2 = "OpenWrt-24.10"/g' package/luci-app-gpsysupgrade/luasrc/model/cbi/gpsysupgrade/sysupgrade.lua
sed -i 's/Variable3 = "*.*"/Variable3 = "x86_64"/g' package/luci-app-gpsysupgrade/luasrc/model/cbi/gpsysupgrade/sysupgrade.lua
sed -i 's/Variable4 = "*.*"/Variable4 = "6.6"/g' package/luci-app-gpsysupgrade/luasrc/model/cbi/gpsysupgrade/sysupgrade.lua
sed -i 's/Variable1 = "*.*"/Variable1 = "oppen321"/g' package/luci-app-gpsysupgrade/root/usr/bin/upgrade.lua
sed -i 's/Variable2 = "*.*"/Variable2 = "OpenWrt-24.10"/g' package/luci-app-gpsysupgrade/root/usr/bin/upgrade.lua
sed -i 's/Variable3 = "*.*"/Variable3 = "x86_64"/g' package/luci-app-gpsysupgrade/root/usr/bin/upgrade.lua
sed -i 's/Variable4 = "*.*"/Variable4 = "6.6"/g' package/luci-app-gpsysupgrade/root/usr/bin/upgrade.lua

./scripts/feeds update -a
./scripts/feeds install -a
