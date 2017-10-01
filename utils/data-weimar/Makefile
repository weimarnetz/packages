include $(TOPDIR)/rules.mk

PKG_NAME:=data-weimar
PKG_RELEASE:=1
PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/data-weimar
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Weimarnetz Defaults
  URL:=https://github.com/weimarnetz/packages/utils/data-weimar
endef


define Package/data-weimar/description
	Defaults for Weimarnetz	
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/data-weimar/install
	$(CP) -R $(PKG_BUILD_DIR)/files/* $(1)/
endef

$(eval $(call BuildPackage,data-weimar))
