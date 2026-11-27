include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-metrics-exporter
PKG_VERSION:=1.1.2
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/weimarnetz-metrics-exporter
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Weimarnetz metrics exporter
  PKGARCH:=all
  DEPENDS:=+weimarnetz-ffwizard +!PACKAGE_luci-app-olsr:weimarnetz-olsrinfo
  # runtime only: listed in the package, but not built along with it
  EXTRA_DEPENDS:=olsrd-mod-jsoninfo (>=0), prometheus-node-exporter-ucode (>=0)
endef

define Package/weimarnetz-metrics-exporter/description
  A collection of tools and scripts to provide metrics.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/weimarnetz-metrics-exporter/install
	$(INSTALL_DIR) $(1)
	$(CP) ./root/* $(1)/
endef

# load the rpcd plugin (wnfirmware) when installed on a running system;
# luci.mk used to do this in its generic postinst
define Package/weimarnetz-metrics-exporter/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || /etc/init.d/rpcd reload 2>/dev/null
exit 0
endef

$(eval $(call BuildPackage,weimarnetz-metrics-exporter))
