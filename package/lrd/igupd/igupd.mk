#####################################################################
# Laird Industrial Gateway igupd
#####################################################################

IGUPD_VERSION = local
IGUPD_SITE = $(BR2_EXTERNAL_LRD_SOM_PATH)/package/lrd/externals/igupd
IGUPD_SITE_METHOD = local
IGUPD_SETUP_TYPE = setuptools

define IGUPD_POST_INSTALL_TARGET_HOOK_CMDS
	$(INSTALL) -D -m 644 -t $(TARGET_DIR)/etc -m 644 $(IGUPD_PKGDIR)/swupdate.cfg
endef

IGUPD_POST_INSTALL_TARGET_HOOKS += IGUPD_POST_INSTALL_TARGET_HOOK_CMDS

define IGUPD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 -t $(TARGET_DIR)/etc/systemd/system $(IGUPD_PKGDIR)/igupd.service
	$(INSTALL) -D -m 644 -t $(TARGET_DIR)/etc/dbus-1/system.d $(IGUPD_PKGDIR)/com.lairdtech.security.UpdateService.conf
endef

$(eval $(python-package))