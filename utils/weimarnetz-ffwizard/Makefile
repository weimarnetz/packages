include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-ffwizard
PKG_RELEASE:=1

PKG_SOURCE_URL=https://github.com/weimarnetz/weimarnetz.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=ad83d771cbc3266e9e9b6bda7b49ebbb9f5f51a1
PKG_SOURCE:=$(PKG_NAME)-$(PKG_SOURCE_VERSION).tar.xz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_SOURCE_VERSION)
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_SOURCE_VERSION)
PKG_VERSION:=$(PKG_SOURCE_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/weimarnetz-ffwizard
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+resolveip +luci-lib-httpclient +freifunk-common
  TITLE:=Weimarnetz Scripts
  URL:=https://github.com/weimarnetz/weimarnetz
endef


define Package/weimarnetz-ffwizard/description
	weimarnetz.
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/weimarnetz-ffwizard/install
	$(CP) -R $(PKG_BUILD_DIR)/files/* $(1)/
	@echo 'FFF_VERSION=$(PKG_SOURCE_VERSION)' >> $(1)/etc/weimarnetz_release
	@echo 'FFF_SOURCE_URL=$(PKG_SOURCE_URL)'  >> $(1)/etc/weimarnetz_release
endef

$(eval $(call BuildPackage,weimarnetz-ffwizard))
