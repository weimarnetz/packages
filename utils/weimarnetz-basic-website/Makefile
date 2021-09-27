include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-basic-website
PKG_RELEASE:=1.0.0

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/weimarnetz-basic-website
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Weimarnetz Basic Website
  DEPENDS:=+weimarnetz-ffwizard
endef

define Package/weimarnetz-basic-website/description
  delivers a simple website as replacement
  for the extensive luci interface
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/weimarnetz-basic-website/install
	$(INSTALL_DIR) $(1)/www/
	$(CP) files/www/index_basic.html $(1)/www/index_basic.html
	$(CP) files/www/cgi-bin-status.html $(1)/www/cgi-bin-status.html
	$(INSTALL_DIR) $(1)/www/cgi-bin/
	$(INSTALL_BIN) files/www/cgi-bin/status.sh $(1)/www/cgi-bin/status.sh
	$(INSTALL_DIR) $(1)/etc/uci-defaults/
	$(CP) files/etc/uci-defaults/weimarnetz-basic-website-defaults $(1)/etc/uci-defaults/weimarnetz-basic-website-defaults
endef

$(eval $(call BuildPackage,weimarnetz-basic-website))
