FFWIZARD_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-ffwizard
PKG_VERSION:=1.0.0
PKG_RELEASE:=2

WEIMARNETZ_PKG_BRANCH:=$(shell cd $(FFWIZARD_DIR)/../.. && git branch --show-current 2>/dev/null)
WEIMARNETZ_PKG_VERSION:=$(shell cd $(FFWIZARD_DIR)/../.. && git describe --always --dirty --tags 2>/dev/null)
WEIMARNETZ_PKG_REV:=$(shell cd $(FFWIZARD_DIR)/../.. && git rev-parse HEAD 2>/dev/null)

PKG_SOURCE_URL=https://github.com/weimarnetz/weimarnetz.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=28c0769794c3e417bfe30e5786b79d8741f000dc
PKG_SOURCE:=$(PKG_NAME)-$(PKG_SOURCE_VERSION).tar.xz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_SOURCE_VERSION)
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_SOURCE_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/weimarnetz-ffwizard
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+resolveip +freifunk-common
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
	@echo 'FFF_SOURCE_URL=$(PKG_SOURCE_URL)' >> $(1)/etc/weimarnetz_release
	@echo 'WEIMARNETZ_PACKAGES_DESCRIPTION=$(WEIMARNETZ_PKG_VERSION)' >> $(1)/etc/weimarnetz_release
	@echo 'WEIMARNETZ_PACKAGES_BRANCH=$(WEIMARNETZ_PKG_BRANCH)' >> $(1)/etc/weimarnetz_release
	@echo 'WEIMARNETZ_PACKAGES_REV=$(WEIMARNETZ_PKG_REV)' >> $(1)/etc/weimarnetz_release
endef

$(eval $(call BuildPackage,weimarnetz-ffwizard))
