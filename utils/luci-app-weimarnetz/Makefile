include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-weimarnetz
PKG_RELEASE:=0.9.5

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

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

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./luasrc $(PKG_BUILD_DIR)/
endef

define Build/Configure
endef

define Build/Compile
	$(TOPDIR)/feeds/packages_weimar/build/i18n-po2lua.pl ./po i18n
endef

define Package/luci-app-weimarnetz/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/weimarnetz
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model
	$(CP) $(PKG_BUILD_DIR)/luasrc/controller/weimarnetz/* $(1)/usr/lib/lua/luci/controller/weimarnetz
	$(CP) $(PKG_BUILD_DIR)/luasrc/model/* $(1)/usr/lib/lua/luci/model
	$(CP) $(PKG_BUILD_DIR)/luasrc/view/* $(1)/usr/lib/lua/luci/view
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(CP) ./i18n/* $(1)/usr/lib/lua/luci/i18n
endef

$(eval $(call BuildPackage,luci-app-weimarnetz))
