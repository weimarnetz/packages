include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-button-config
PKG_RELEASE:=0.9.5

define Package/weimarnetz-button-config
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Weimarnetz Button Config
  DEPENDS:=+luci-base +weimarnetz-ffwizard
endef

define Package/weimarnetz-button-config/description
  a package to configure behaviour of
  hardware buttons like the reset button
endef

include ../../luci.mk

# $(eval $(call BuildPackage,weimarnetz-button-config))
