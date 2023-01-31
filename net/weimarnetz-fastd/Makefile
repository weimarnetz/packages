include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-fastd-config
PKG_RELEASE:=1.0.0
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

define Package/weimarnetz-fastd-config
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  TITLE:=Weimarnetz Fastd Config
  DEPENDS:=+fastd +kmod-l2tp +kmod-l2tp-eth +weimarnetz-ffwizard
endef

define Package/weimarnetz-fastd-config/description
  a package to configure our fastd
  vpn service to connect routers and
  deroute internet traffic.
endef

include ../../luci.mk

# $(eval $(call BuildPackage,weimarnetz-fastd-config))
