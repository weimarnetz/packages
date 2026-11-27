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
  DEPENDS:=+weimarnetz-ffwizard
  # runtime only: listed in the package, but not built along with it
  EXTRA_DEPENDS:=olsrd-mod-jsoninfo (>=0), ca-bundle (>=0), \
	ucode (>=0), ucode-mod-fs (>=0), ucode-mod-ubus (>=0), ucode-mod-uci (>=0), \
	ucode-mod-resolv (>=0), ucode-mod-socket (>=0), ucode-mod-uloop (>=0), \
	ucode-mod-uclient (>=0)
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
