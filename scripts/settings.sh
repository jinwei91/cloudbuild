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

# sing-box: build from iskhakovt fork @ dfd19d1 (= v1.14.3 + REALITY X25519MLKEM768 fix)
SB_DIR="$(find feeds -maxdepth 5 -type d -path '*/net/sing-box' | head -n1)"
FORK_SHA=dfd19d104fd1dbed9428694e166bf79283c73686
if [ -n "$SB_DIR" ] && [ -f "$SB_DIR/Makefile" ]; then
  sed -i '/^PKG_BUILD_DIR:=/d' "$SB_DIR/Makefile"
  sed -i \
    -e "s|^PKG_SOURCE:=.*|PKG_SOURCE:=sing-box-$FORK_SHA.tar.gz|" \
    -e "s|^PKG_SOURCE_URL:=.*|PKG_SOURCE_URL:=https://codeload.github.com/iskhakovt/sing-box/tar.gz/$FORK_SHA?|" \
    -e "s|^PKG_HASH:=.*|PKG_HASH:=fe49aa96ee214b3911a44fc5a6d6c5d180008b38f86fbfabb6692dbb8e8b2fd1|" \
    -e "s|^PKG_RELEASE:=.*|PKG_RELEASE:=2|" \
    -e "/^PKG_HASH:=/a PKG_BUILD_DIR:=\$(BUILD_DIR)/sing-box-$FORK_SHA" \
    "$SB_DIR/Makefile"
  for k in "PKG_SOURCE:=sing-box-$FORK_SHA.tar.gz" "PKG_HASH:=fe49aa96" "PKG_BUILD_DIR:=."; do
    grep -q "^$k" "$SB_DIR/Makefile" || { echo "::error::sing-box source rewrite failed: $k"; exit 1; }
  done
  echo "sing-box source -> iskhakovt/sing-box@$FORK_SHA"
else
  echo "::error::feeds/packages/net/sing-box not found"
  exit 1
fi
