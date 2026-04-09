FEED_OPKG_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-feed-opkg
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

WEIMARNETZ_OPENWRT_RELEASE?=unknown
FEED_BASE_URL:=https://buildbot.weimarnetz.de/builds/brauhaus/packages/stable
FEED_URL:=$(FEED_BASE_URL)/$(WEIMARNETZ_OPENWRT_RELEASE)/$(BOARD)/$(SUBTARGET)

define Package/weimarnetz-feed-opkg
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Weimarnetz package feed configuration for opkg
  PKGARCH:=all
endef

define Package/weimarnetz-feed-opkg/description
  Configures the Weimarnetz and Freifunk package feeds for opkg
  and installs the feed signing key for package verification.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/weimarnetz-feed-opkg/install
	$(INSTALL_DIR) $(1)/etc/opkg/keys
	$(INSTALL_DATA) $(FEED_OPKG_DIR)/files/key-build.pub \
		$(1)/etc/opkg/keys/$$($(STAGING_DIR_HOST)/bin/usign -F -p $(FEED_OPKG_DIR)/files/key-build.pub)
	echo "src/gz weimarnetz_stable $(FEED_URL)/weimarnetz_packages" > $(1)/etc/opkg/customfeeds.conf
	echo "src/gz freifunk_stable $(FEED_URL)/freifunk_packages" >> $(1)/etc/opkg/customfeeds.conf
endef

$(eval $(call BuildPackage,weimarnetz-feed-opkg))
