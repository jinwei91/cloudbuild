#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
git clone https://github.com/openwrt/openwrt
rm -rf package/network/utils/ethtool
cp -rf ./openwrt/package/network/utils/ethtool package/network/utils/ethtool

rm -rf package/network/ipv6/6in4
cp -rf ./openwrt/package/network/ipv6/6in4 package/network/ipv6/6in4

rm -rf package/system/urandom-seed
cp -rf ./openwrt/package/system/urandom-seed package/system/urandom-seed

rm -rf package/system/ubox
cp -rf ./openwrt/package/system/ubox package/system/ubox

rm -rf package/system/ubus
cp -rf ./openwrt/package/system/ubus package/system/ubus

rm -rf package/system/rpcd
cp -rf ./openwrt/package/system/rpcd package/system/rpcd

