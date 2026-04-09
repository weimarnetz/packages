BANNER_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-banner
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/weimarnetz-banner
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Weimarnetz login banner
  DEPENDS:=+weimarnetz-ffwizard
  PKGARCH:=all
endef

define Package/weimarnetz-banner/description
  Installs the Weimarnetz/Freifunk Weimar banner displayed at login.
  The banner is generated on first boot with version information
  from OpenWrt and the Weimarnetz package feed.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/weimarnetz-banner/install
	$(INSTALL_DIR) $(1)/usr/share/weimarnetz
	$(INSTALL_DATA) $(BANNER_DIR)/files/usr/share/weimarnetz/banner.template \
		$(1)/usr/share/weimarnetz/banner.template
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) $(BANNER_DIR)/files/etc/uci-defaults/99-weimarnetz-banner \
		$(1)/etc/uci-defaults/99-weimarnetz-banner
endef

$(eval $(call BuildPackage,weimarnetz-banner))
