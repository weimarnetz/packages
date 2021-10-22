include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-weimarnetz
PKG_RELEASE:=0.9.5

define Package/luci-app-weimarnetz
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Weimarnetz LuCI APP
  DEPENDS:=+luci-base +weimarnetz-ffwizard
endef

define Package/luci-app-weimarnetz/description
  provide weimarnetz specific pages
  to configure routers
endef

include ../../luci.mk

# $(eval $(call BuildPackage,luci-app-weimarnetz))
