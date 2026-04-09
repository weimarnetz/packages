FEED_APK_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-feed-apk
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

WEIMARNETZ_OPENWRT_RELEASE?=unknown
FEED_BASE_URL:=https://buildbot.weimarnetz.de/builds/brauhaus/packages/stable
FEED_URL:=$(FEED_BASE_URL)/$(WEIMARNETZ_OPENWRT_RELEASE)/$(BOARD)/$(SUBTARGET)

define Package/weimarnetz-feed-apk
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Weimarnetz package feed configuration for apk
  PKGARCH:=all
endef

define Package/weimarnetz-feed-apk/description
  Configures the Weimarnetz and Freifunk package repositories for apk
  and installs the feed signing key for package verification.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/weimarnetz-feed-apk/install
	$(INSTALL_DIR) $(1)/etc/apk/repositories.d
	$(INSTALL_DIR) $(1)/etc/apk/keys
	$(INSTALL_DATA) $(FEED_APK_DIR)/files/public-key.pem $(1)/etc/apk/keys/weimarnetz-public-key.pem
	echo "$(FEED_URL)/weimarnetz_packages" > $(1)/etc/apk/repositories.d/weimarnetz.list
	echo "$(FEED_URL)/freifunk_packages" >> $(1)/etc/apk/repositories.d/weimarnetz.list
endef

$(eval $(call BuildPackage,weimarnetz-feed-apk))
