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

# Update Default Login IP & Openwrt Broadcast IP
sed -i "s/192\.168\.[0-9]*\.[0-9]*/192\.168\.50\.1/g" package/base-files/files/bin/config_generate
sed -i "s/192\.168\.[0-9]*\.[0-9]*/192\.168\.50\.1/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")

# Update Hostname
sed -i "s/hostname='.*'/hostname='OpenWrt'/g" package/base-files/files/bin/config_generate
sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ Built on $OPENWRT_BUILD_DATE')/g" $(find ./feeds/luci/modules/luci-mod-status/ -type f -name "10_system.js")

# Update Default Theme
sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" $(find ./feeds/luci/collections/ -type f -name "Makefile")
cd $GITHUB_WORKSPACE/$WORKING_DIR/package
if [ -d *"luci-theme-argon"* ]; then
	cd ./luci-theme-argon
	sed -i "s/primary '.*'/primary '#31a1a1'/; s/'0.2'/'0.5'/; s/'600'/'normal'/" ./luci-app-argon-config/root/etc/config/argon
fi

cd $GITHUB_WORKSPACE/$WORKING_DIR

# Update Boot Order of qca-nss-drv
NSS_DRV="./feeds/nss_packages/qca-nss-drv/files/qca-nss-drv.init"
if [ -f "$NSS_DRV" ]; then
	sed -i 's/START=.*/START=85/g' $NSS_DRV
fi

# Update Boot Order of qca-nss-pbuf
NSS_PBUF="./kernel/mac80211/files/qca-nss-pbuf.init"
if [ -f "$NSS_PBUF" ]; then
	sed -i 's/START=.*/START=86/g' $NSS_PBUF
fi

# Remove luci-app-attendedsysupgrade
sed -i "/attendedsysupgrade/d" $(find ./feeds/luci/collections/ -type f -name "Makefile")
ASU_FILE=$(find ./feeds/luci/applications/luci-app-attendedsysupgrade/ -type f -name "11_upgrades.js")
if [ -f "$ASU_FILE" ]; then
	rm -rf $ASU_FILE
fi

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
#find $DTS_PATH -type f -name "ipq6018-nowifi.dtsi" -exec sed -i '/&q6_etr_region/,/&ramoops_region/ s/^/# /' {} +
