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

# Modify the default IP address
sed -i 's/192.168.1.1/192.168.16.1/g' \
  package/base-files/files/bin/config_generate

# Recursively remove fchomo and nikki packages
rm -rf feeds/*/luci-app-fchomo
rm -rf package/feeds/*/luci-app-fchomo
rm -rf feeds/*/nikki
rm -rf package/feeds/*/nikki

# Lower the CMake version requirement for rpcd-mod-luci and other LuCI plugins
find feeds/luci/ -type f -name "CMakeLists.txt" \
  -exec sed -i 's/3\.31/3.25/g' {} \;

# Remove obsolete SSR components that are no longer supported
# and may cause SSL build failures
rm -rf feeds/*/shadowsocksr-libev
rm -rf package/feeds/*/shadowsocksr-libev
rm -rf feeds/*/luci-app-ssr-plus
rm -rf package/feeds/*/luci-app-ssr-plus

# Remove luci-app-nikki because its required core package is unavailable
rm -rf feeds/passwall_dep/luci-app-nikki
rm -rf package/feeds/passwall_dep/luci-app-nikki

# Remove HomeProxy and Dockerman because required ucode modules are unavailable
rm -rf feeds/luci/applications/luci-app-homeproxy
rm -rf package/feeds/luci/luci-app-homeproxy
rm -rf feeds/luci/applications/luci-app-dockerman
rm -rf package/feeds/luci/luci-app-dockerman

# Keep HAProxy because luci-app-passwall depends on it
# Do not remove feeds/packages/net/haproxy

# Force Tailscale to a specific version before package download/compile
if [ -f feeds/packages/net/tailscale/Makefile ]; then
  sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.102.2/g' \
    feeds/packages/net/tailscale/Makefile
  sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/g' \
    feeds/packages/net/tailscale/Makefile
fi
