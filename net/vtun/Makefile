#
# Copyright (C) 2006-2009 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=vtun
PKG_VERSION:=3.0.2
PKG_RELEASE:=3

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=@SF/vtun
PKG_HASH:=db26d4dbc35a2b3d65519f68b8ae55c80d7ec4e6569aeec7a432aa82f24c56d6

include $(INCLUDE_DIR)/package.mk

define Package/vtun
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+kmod-tun +VTUN_LZO:liblzo +VTUN_LZO:zlib +VTUN_SSL:libopenssl
  TITLE:=VPN tunneling daemon
  URL:=http://vtun.sourceforge.net
  SUBMENU:=VPN
  MENU:=1
endef

define Package/vtun/config
menu "Configuration"
        depends on PACKAGE_vtun

config VTUN_config
	bool

	depends on PACKAGE_vtun
	config VTUN_LZO
		bool "enable vtun compression"
		help
			vtun tunnels will be compressed
		default n 

	config VTUN_SSL
		bool "enable vtun ssl encryption"
		help
			vtun tunnels will be encrypted
		default n 
endmenu
endef

define Package/vtun/conffiles
/etc/vtund.conf
endef

CONFIGURE_ARGS += \
	$(if $(CONFIG_VTUN_LZO),--with-lzo-lib="$(STAGING_DIR)/usr/lib/",--disable-zlib) \
	$(if $(CONFIG_VTUN_LZO),--with-lzo-headers="$(STAGING_DIR)/usr/include/lzo",--disable-lzo) \
	$(if $(CONFIG_VTUN_SSL),--with-ssl-headers="$(STAGING_DIR)/usr/lib/",--disable-ssl) \

CONFIGURE_VARS += \
	LIBS="$(TARGET_LDFLAGS)" \
	$(if $(CONFIG_VTUN_LZO),LZO_HDR_DIR="$(STAGING_DIR)/usr/include/lzo") \
	$(if $(CONFIG_VTUN_SSL),BLOWFISH_HDR_DIR="$(STAGING_DIR)/usr/include/openssl") \
	$(if $(CONFIG_VTUN_SSL),SSL_HDR_DIR="$(STAGING_DIR)/usr/include/openssl") \

TARGET_CFLAGS += -DHAVE_WORKING_FORK

define Build/Compile
	$(call Build/Compile/Default,vtund)
endef

define Package/vtun/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/vtund.conf $(1)/etc/
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/vtund $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,vtun))
