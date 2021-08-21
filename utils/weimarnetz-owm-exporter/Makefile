include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-owm-exporter
PKG_RELEASE:=1.0.0

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/weimarnetz-owm-exporter
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Weimarnetz owm json exporter 
  DEPENDS:=+weimarnetz-ffwizard
endef

define Package/weimarnetz-owm-exporter/description
  this is a reimplementation of the well-known 
	owm.lua. It helps reducing lua dependencies.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/weimarnetz-owm-exporter/install
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(CP) -R files/owm.sh $(1)/usr/sbin/owm.sh
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(CP) files/owm-defaults $(1)/etc/uci-defaults/owm
endef

$(eval $(call BuildPackage,weimarnetz-owm-exporter))
