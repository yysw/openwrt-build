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
sed -i 's/192.168.1.1/192.168.16.1/g' package/base-files/files/bin/config_generate

# delete recusively dependencies
rm -rf feeds/*/luci-app-fchomo
rm -rf package/feeds/*/luci-app-fchomo
rm -rf feeds/*/nikki
rm -rf package/feeds/*/nikki

# force lower down rpcd-mod-luci and other luci plugins' CMake version requirements
find feeds/luci/ -type f -name "CMakeLists.txt" -exec sed -i 's/3.31/3.25/g' {} \;

# Remove obsolete SSR components that are no longer supported and causing SSL build failures
rm -rf feeds/*/shadowsocksr-libev package/feeds/*/shadowsocksr-libev
rm -rf feeds/*/luci-app-ssr-plus package/feeds/*/luci-app-ssr-plus

# Remove luci-app-nikki due to missing required core components
rm -rf feeds/passwall_dep/luci-app-nikki

# Remove homeproxy and dockerman due to missing ucode module dependencies
rm -rf feeds/luci/applications/luci-app-homeproxy
rm -rf feeds/luci/applications/luci-app-dockerman

# Remove HAProxy if advanced load balancing is not needed to avoid libcrypt-compat dependency issues
rm -rf feeds/packages/net/haproxy
