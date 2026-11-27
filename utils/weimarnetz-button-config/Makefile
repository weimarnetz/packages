include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-button-config
PKG_VERSION:=1.0.1
PKG_RELEASE:=1

# This is a LuCI app (view, menu, translations), so it keeps using luci.mk.
# luci.mk defines Package/$(PKG_NAME) itself: title and dependencies have
# to be passed via the LUCI_* variables, an own define would be dropped.
LUCI_TITLE:=Weimarnetz Button Config
LUCI_DEPENDS:=+weimarnetz-ffwizard
# runtime only: listed in the package, but not built along with it
LUCI_EXTRA_DEPENDS:=luci-base (>=0)
LUCI_DESCRIPTION:=a package to configure behaviour of hardware buttons like the reset button

define Package/weimarnetz-button-config/postrm
	#!/bin/sh
	cp /rom/etc/rc.button/wps /etc/rc.button/wps
	cp /rom/etc/rc.button/reset /etc/rc.button/reset
endef

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
