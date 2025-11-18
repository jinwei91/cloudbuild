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

# Update Default Login IP & Openwrt Broadcast IP
sed -i "s/192\.168\.[0-9]*\.[0-9]*/192\.168\.50\.1/g" package/base-files/files/bin/config_generate
sed -i "s/192\.168\.[0-9]*\.[0-9]*/192\.168\.50\.1/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")

# Update Hostname
sed -i "s/hostname='.*'/hostname='OpenWrt'/g" package/base-files/files/bin/config_generate
sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ #Built on $OPENWRT_BUILD_DATE #')/g" $(find ./feeds/luci/modules/luci-mod-status/ -type f -name "10_system.js")

# Update Default Theme
sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" $(find ./feeds/luci/collections/ -type f -name "Makefile")
cd $GITHUB_WORKSPACE/$WORKING_DIR/package
if [ -d *"luci-theme-argon"* ]; then
	cd ./luci-theme-argon
	sed -i "s/primary '.*'/primary '#31a1a1'/; s/'0.2'/'0.5'/; s/'600'/'normal'/" ./luci-app-argon-config/root/etc/config/argon
fi

cd $GITHUB_WORKSPACE/$WORKING_DIR

# Update Boot Order of qca-nss-drv
NSS_DRV="$GITHUB_WORKSPACE/$WORKING_DIR/feeds/nss_packages/qca-nss-drv/files/qca-nss-drv.init"
if [ -f "$NSS_DRV" ]; then
	sed -i 's/START=.*/START=85/g' $NSS_DRV
fi

# Update Boot Order of qca-nss-pbuf
NSS_PBUF="$GITHUB_WORKSPACE/$WORKING_DIR/kernel/mac80211/files/qca-nss-pbuf.init"
if [ -f "$NSS_PBUF" ]; then
	sed -i 's/START=.*/START=86/g' $NSS_PBUF
fi

# Remove luci-app-attendedsysupgrade
ASU_FILE=$(find $GITHUB_WORKSPACE/$WORKING_DIR/feeds/luci/applications/luci-app-attendedsysupgrade/ -type f -name "11_upgrades.js")
if [ -f "$ASU_FILE" ]; then
	rm -rf $ASU_FILE
fi

# Update the reserved size of the q6_region memory region in the NSS driver.
# ipq6018.dtsi default: 85MB
# ipq6018-512m.dtsi default: 55MB
# Enable Wi-Fi: at least 54MB
# The followings are the reconfigurations to reserve 16MB, 32MB, 64MB, and 96MB.
# sed -i 's/reg = <0x0 0x4ab00000 0x0 0x[0-9a-f]\+>/reg = <0x0 0x4ab00000 0x0 0x01000000>/' $GITHUB_WORKSPACE/$WORKING_DIR/target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6018-512m.dtsi
# sed -i 's/reg = <0x0 0x4ab00000 0x0 0x[0-9a-f]\+>/reg = <0x0 0x4ab00000 0x0 0x02000000>/' $GITHUB_WORKSPACE/$WORKING_DIR/target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6018-512m.dtsi
sed -i 's/reg = <0x0 0x4ab00000 0x0 0x[0-9a-f]\+>/reg = <0x0 0x4ab00000 0x0 0x04000000>/' $GITHUB_WORKSPACE/$WORKING_DIR/target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6018-512m.dtsi
# sed -i 's/reg = <0x0 0x4ab00000 0x0 0x[0-9a-f]\+>/reg = <0x0 0x4ab00000 0x0 0x06000000>/' $GITHUB_WORKSPACE/$WORKING_DIR/target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6018-512m.dtsi
