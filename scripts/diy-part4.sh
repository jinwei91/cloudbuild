#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.1/g' package/base-files/files/bin/config_generate

# Update theme argonv3
rm -rf feeds/luci/themes/luci-theme-argonv3
git clone https://github.com/jerrykuku/luci-theme-argon feeds/luci/themes/luci-theme-argonv3

# Update theme argonv3
rm -rf feeds/luci/themes/luci-theme-design
git clone https://github.com/0x676e67/luci-theme-design feeds/luci/themes/luci-theme-design

# Change Default Design
sed -i 's/luci-theme-bootstrap/luci-theme-design/g' feeds/luci/collections/luci/Makefile
sed -i 's/Bootstrap/Design/g' feeds/luci/collections/luci/Makefile

git clone https://github.com/sdf8057/luci
rm -rf feeds/luci/applications/luci-app-cpufreq
cp -rf ./luci/applications/luci-app-cpufreq feeds/luci/applications/luci-app-cpufreq

rm -rf feeds/packages/net/{brook,chinadns-ng,dns2socks,dns2tcp,gn,hysteria,ipt2socks,microsocks,mosdns,naiveproxy,pdnsd-alt,redsocks2,shadow-tls,shadowsocks-rust,shadowsocksr-libev,simple-obfs,sing-box,ssocks,tcping,trojan-go,trojan-plus,trojan,tuic-client,v2dat,v2ray-core,v2ray-geodata,v2ray-plugin,v2raya,xray-core,xray-plugin}
git clone https://github.com/kenzok8/small
rm -rf feeds/packages/net/luci-app-mosdns
mv small/* feeds/packages/net/
rm -rf small
rm -rf feeds/packages/net/README.md
rm -rf feeds/packages/net/LICENSE
rm -rf feeds/packages/lang/lua-neturl
mv feeds/packages/net/lua-neturl feeds/packages/lang/lua-neturl
rm -rf feeds/luci/applications/{luci-app-bypass,luci-app-passwall,luci-app-passwall2,luci-app-ssr-plus,luci-app-mosdns}
mv feeds/packages/net/luci-app-bypass feeds/luci/applications/luci-app-bypass
mv feeds/packages/net/luci-app-passwall feeds/luci/applications/luci-app-passwall
mv feeds/packages/net/luci-app-passwall2 feeds/luci/applications/luci-app-passwall2
mv feeds/packages/net/luci-app-ssr-plus feeds/luci/applications/luci-app-ssr-plus
mv feeds/packages/net/luci-app-mosdns feeds/luci/applications/luci-app-mosdns

git clone https://github.com/xiaorouji/openwrt-passwall-packages
rm -rf feeds/packages/net/shadowsocksr-libev
mv openwrt-passwall-packages/shadowsocksr-libev feeds/packages/net/shadowsocksr-libev
rm -rf openwrt-passwall-packages

git clone https://github.com/sbwml/package_libs_nghttp3 package/libs/nghttp3
git clone https://github.com/sbwml/package_libs_ngtcp2 package/libs/ngtcp2
rm -rf feeds/packages/net/curl
git clone https://github.com/sbwml/feeds_packages_net_curl feeds/packages/net/curl

rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

rm -rf feeds/packages/net/ddns-go
rm -rf feeds/luci/applications/luci-app-ddns-go
git clone https://github.com/sirpdboy/luci-app-ddns-go
mv luci-app-ddns-go/luci-app-ddns-go feeds/luci/applications/luci-app-ddns-go
mv luci-app-ddns-go/ddns-go feeds/packages/net/ddns-go
rm -rf luci-app-ddns-go

rm -rf feeds/packages/net/msd_lite
git clone https://github.com/ximiTech/msd_lite feeds/packages/net/msd_lite
rm -rf feeds/luci/applications/luci-app-msd_lite
git clone https://github.com/ximiTech/luci-app-msd_lite feeds/luci/applications/luci-app-msd_lite

rm -rf feeds/luci/applications/luci-app-dnsfilter
git clone https://github.com/kiddin9/luci-app-dnsfilter feeds/luci/applications/luci-app-dnsfilter

rm -rf ./tmp

#更新luci和packages
./scripts/feeds update -i packages
./scripts/feeds install -a -p packages
./scripts/feeds update -i luci
./scripts/feeds install -a -p luci

#下载自己的默认配置
rm -rf .config
curl -sfL https://raw.githubusercontent.com/tangyl2000/zn-m2/main/zn-m2-config-hxlls -o .config

make menuconfig

