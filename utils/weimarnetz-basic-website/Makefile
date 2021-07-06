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
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./luasrc $(PKG_BUILD_DIR)/
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/weimarnetz-basic-website/install
	$(CP) -R $(PKG_BUILD_DIR)/root/* $(1)/
endef

$(eval $(call BuildPackage,weimarnetz-basic-website))
