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
