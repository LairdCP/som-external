#############################################################
#
# Laird Legacy Software
#
#############################################################

define LRD_LEGACY_INSTALL_TARGET_CMDS
	rsync -rlpDWKv $(BR2_EXTERNAL_LRD_SOM_PATH)/package/lrd/externals/lrd-legacy/rootfs-additions/ $(TARGET_DIR)/
endef

$(eval $(generic-package))
