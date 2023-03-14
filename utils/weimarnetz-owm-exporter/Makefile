include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-owm-exporter
PKG_RELEASE:=1.1.0

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/weimarnetz-owm-exporter
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Weimarnetz owm json exporter 
  DEPENDS:=+weimarnetz-ffwizard +olsrd-mod-jsoninfo
endef

define Package/weimarnetz-owm-exporter/description
  this is a reimplementation of the well-known 
	owm.lua. It helps reducing lua dependencies.
endef

include ../../luci.mk

# $(eval $(call BuildPackage,weimarnetz-owm-exporter))
