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

# Modify Default Login IP & 修改immortalwrt.lan关联IP
sed -i "s/192\.168\.[0-9]*\.[0-9]*/192\.168\.50\.1/g" package/base-files/files/bin/config_generate
sed -i "s/192\.168\.[0-9]*\.[0-9]*/192\.168\.50\.1/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")

# Modify Default Theme
sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" $(find ./feeds/luci/collections/ -type f -name "Makefile")

# Modify Hostname
sed -i "s/hostname='.*'/hostname='OpenWrt'/g" package/base-files/files/bin/config_generate
sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ #Built by jinwei91 ipq60xx-$(date +%Y%m%d)#')/g" $(find ./feeds/luci/modules/luci-mod-status/ -type f -name "10_system.js")

# Modify Distribution
#sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt IPQ60xx (build time: $(date +%Y%m%d))'/g"  package/base-files/files/etc/openwrt_release
