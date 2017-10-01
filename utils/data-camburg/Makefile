include $(TOPDIR)/rules.mk

PKG_NAME:=data-camburg
PKG_RELEASE:=1
PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/data-camburg
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Camburg Defaults
  URL:=https://github.com/weimarnetz/packages/utils/data-camburg
endef


define Package/data-camburg/description
	Defaults for Camburg 	
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/data-camburg/install
	$(CP) -R $(PKG_BUILD_DIR)/files/* $(1)/
endef

$(eval $(call BuildPackage,data-camburg))
