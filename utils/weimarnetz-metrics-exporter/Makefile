include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-metrics-exporter
PKG_RELEASE:=1.0.0

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/weimarnetz-metrics-exporter
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Weimarnetz owm json exporter 
  DEPENDS:=+weimarnetz-ffwizard +olsrd-mod-jsoninfo prometheus-node-exporter-ucode
endef

define Package/weimarnetz-metrics-exporter/description
  this is a collection of tools and scripts to 
	provide metrics.
endef

include ../../luci.mk

# $(eval $(call BuildPackage,weimarnetz-metrics-exporter))
