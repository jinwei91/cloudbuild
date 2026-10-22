#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Update System Name
find . -type f -exec sed -i 's/ImmortalWRT/ImmortalWrt/g' {} +

# Update Default IP
sed -i 's/192\.168\.[0-9]*\.[0-9]*/192.168.50.1/g' package/base-files/files/bin/config_generate
find ./feeds/luci/modules/luci-mod-system/ -type f -name 'flash.js' -exec sed -i 's/192\.168\.[0-9]*\.[0-9]*/192.168.50.1/g' {} +

# Update Hostname
sed -i "s/hostname='.*'/hostname='OpenWrt'/g" package/base-files/files/bin/config_generate
find ./feeds/luci/modules/luci-mod-status/ -type f -name "10_system.js" -exec sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ Built on $OPENWRT_BUILD_DATE')/g" {} +

# Update Default Theme
find ./feeds/luci/collections/ -type f -name "Makefile" -exec sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" {} +

# Update Qualcomm DTS Files
DTS_PATH="./target/linux/qualcommax/dts/"
find $DTS_PATH -type f ! -iname '*nowifi*' -exec sed -i 's/ipq\(6018\|8074\).dtsi/ipq\1-nowifi.dtsi/g' {} +
