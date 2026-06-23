include $(TOPDIR)/rules.mk

PKG_NAME:=weimarnetz-metrics-exporter
PKG_VERSION:=1.1.0
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

LUCI_TITLE:=Weimarnetz owm json exporter
LUCI_DEPENDS:=+weimarnetz-ffwizard +olsrd-mod-jsoninfo +prometheus-node-exporter-ucode +!PACKAGE_luci-app-olsr:weimarnetz-olsrinfo
LUCI_DESCRIPTION:=this is a collection of tools and scripts to provide metrics.

include ../../luci.mk

# Standalone olsrinfo rpcd backend. luci-app-olsr ships the same olsrinfo
# script/ACL, so the OLSR metrics break on images built without it. This
# sub-package provides olsrinfo on its own and declares a conflict with
# luci-app-olsr to avoid shipping the same files twice.
define Package/weimarnetz-olsrinfo
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=olsrinfo rpcd backend (standalone)
  DEPENDS:=+olsrd-mod-jsoninfo
  CONFLICTS:=luci-app-olsr
  PKGARCH:=all
endef

define Package/weimarnetz-olsrinfo/description
  Standalone olsrinfo rpcd script and ACL, taken from luci-app-olsr. Provides
  the olsrinfo ubus object used to collect OLSR metrics on images that are
  built without luci-app-olsr.
endef

define Package/weimarnetz-olsrinfo/install
	$(INSTALL_DIR) $(1)/usr/libexec/rpcd
	$(INSTALL_BIN) ./files/olsrinfo $(1)/usr/libexec/rpcd/olsrinfo
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) ./files/weimarnetz-olsrinfo.acl.json $(1)/usr/share/rpcd/acl.d/weimarnetz-olsrinfo.json
endef

define Package/weimarnetz-olsrinfo/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || /etc/init.d/rpcd reload 2>/dev/null
exit 0
endef

$(eval $(call BuildPackage,weimarnetz-olsrinfo))
