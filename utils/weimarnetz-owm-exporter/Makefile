include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-owm-exporter
PKG_VERSION:=2.0.0
PKG_RELEASE:=1
PKG_LICENSE:=GPL-2.0-only

include $(INCLUDE_DIR)/package.mk

define Package/weimarnetz-owm-exporter
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Weimarnetz owm json exporter
  PKGARCH:=all
  DEPENDS:=+weimarnetz-ffwizard +olsrd-mod-jsoninfo \
	+ucode +ucode-mod-fs +ucode-mod-ubus +ucode-mod-uci +ucode-mod-resolv \
	+ucode-mod-socket +ucode-mod-uloop +ucode-mod-uclient +ca-bundle
endef

define Package/weimarnetz-owm-exporter/description
  ucode script that registers the node at the community map
  (openwifimap API). Based on falter-berlin-owm-ucode by Freifunk Berlin.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/weimarnetz-owm-exporter/install
	$(INSTALL_DIR) $(1)
	$(CP) ./root/* $(1)/
endef

$(eval $(call BuildPackage,weimarnetz-owm-exporter))
