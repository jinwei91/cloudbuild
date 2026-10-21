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

# Default IP
sed -i 's/192\.168\.[0-9]*\.[0-9]*/192.168.50.1/g' package/base-files/files/bin/config_generate
find ./feeds/luci/modules/luci-mod-system/ -type f -name 'flash.js' -exec sed -i 's/192\.168\.[0-9]*\.[0-9]*/192.168.50.1/g' {} +

# Update Hostname
sed -i "s/hostname='.*'/hostname='OpenWrt'/g" package/base-files/files/bin/config_generate
find ./feeds/luci/modules/luci-mod-status/ -type f -name "10_system.js" -exec sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ Built on $OPENWRT_BUILD_DATE')/g" {} +

# Update Default Theme
find ./feeds/luci/collections/ -type f -name "Makefile" -exec sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" {} +

# Update Qualcomm DTS Files
# q6_region reserved ram:
# ipq6018.dtsi: 85MB, 0x05500000;
# ipq6018-512m.dtsi: 55MB, 0x3700000;
# 16MB: 0x01000000;
# 32MB: 0x02000000;
# 64MB: 0x04000000;
# 96MB: 0x06000000;
DTS_PATH="./target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/"
find $DTS_PATH -type f ! -iname '*nowifi*' -exec sed -i 's/ipq\(6018\|8074\).dtsi/ipq\1-nowifi.dtsi/g' {} +
find $DTS_PATH -type f -name "ipq6018-nowifi.dtsi" -exec sed -i 's/reg = <0x0 0x4ab00000 0x0 0x[0-9a-f]\+>/reg = <0x0 0x4ab00000 0x0 0x3700000>/' {} +
#find $DTS_PATH -type f -name "ipq6018-common.dtsi" -exec perl -i -0777 -pe 's/opp-1608000000 {\s*opp-supported-hw = <0x1>;.*?}/opp-1608000000 {\n\t\topp-supported-hw = <0xf>;\n\t}/gs' {} +
