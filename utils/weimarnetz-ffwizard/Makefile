FFWIZARD_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-ffwizard
PKG_VERSION:=2.1.0
PKG_RELEASE:=1

WEIMARNETZ_VENDOR_URL:=https://github.com/weimarnetz/packages/utils/weimarnetz-ffwizard

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

WEIMARNETZ_PKG_BRANCH:=$(shell cd $(FFWIZARD_DIR)/../.. && git branch --show-current 2>/dev/null)
WEIMARNETZ_PKG_VERSION:=$(shell cd $(FFWIZARD_DIR)/../.. && git describe --always --dirty --tags 2>/dev/null)
WEIMARNETZ_PKG_REV:=$(shell cd $(FFWIZARD_DIR)/../.. && git rev-parse HEAD 2>/dev/null)

include $(INCLUDE_DIR)/package.mk

define Package/weimarnetz-ffwizard
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+resolveip +freifunk-common
  TITLE:=Weimarnetz Scripts
  URL:=https://github.com/weimarnetz/packages/utils/weimarnetz-ffwizard
endef


define Package/weimarnetz-ffwizard/description
	weimarnetz.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/weimarnetz-ffwizard/install
	$(CP) -R $(FFWIZARD_DIR)/files/* $(1)/
	@echo 'FFF_SOURCE_URL=$(WEIMARNETZ_VENDOR_URL)' >> $(1)/etc/weimarnetz_release
	@echo 'WEIMARNETZ_PACKAGES_DESCRIPTION=$(WEIMARNETZ_PKG_VERSION)' >> $(1)/etc/weimarnetz_release
	@echo 'WEIMARNETZ_PACKAGES_BRANCH=$(WEIMARNETZ_PKG_BRANCH)' >> $(1)/etc/weimarnetz_release
	@echo 'WEIMARNETZ_PACKAGES_REV=$(WEIMARNETZ_PKG_REV)' >> $(1)/etc/weimarnetz_release
endef

$(eval $(call BuildPackage,weimarnetz-ffwizard))
