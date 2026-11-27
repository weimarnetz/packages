include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-fastd-config
PKG_VERSION:=1.0.1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/weimarnetz-fastd-config
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  TITLE:=Weimarnetz Fastd Config
  PKGARCH:=all
  DEPENDS:=+weimarnetz-ffwizard
  # runtime only: listed in the package, but not built along with it
  EXTRA_DEPENDS:=fastd (>=0), kmod-l2tp (>=0), kmod-l2tp-eth (>=0)
endef

define Package/weimarnetz-fastd-config/description
  a package to configure our fastd
  vpn service to connect routers and
  deroute internet traffic.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/weimarnetz-fastd-config/install
	$(INSTALL_DIR) $(1)
	$(CP) ./root/* $(1)/
endef

$(eval $(call BuildPackage,weimarnetz-fastd-config))
