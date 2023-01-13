##########################################################################
# Sentrius IG60 lrd_bt_utils
##########################################################################

LRD_BT_UTILS_VERSION = local
LRD_BT_UTILS_SITE = $(BR2_EXTERNAL_LRD_SOM_PATH)/package/lrd/externals/lrd-bt-utils
LRD_BT_UTILS_SITE_METHOD = local
LRD_BT_UTILS_SETUP_TYPE = setuptools

$(eval $(python-package))
