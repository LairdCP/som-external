#####################################################################
# Summit Remote Control Manager (RCM) Chrony Plugin
#####################################################################

SUMMIT_RCM_CHRONY_PLUGIN_VERSION = local
SUMMIT_RCM_CHRONY_PLUGIN_SITE = $(BR2_EXTERNAL_LRD_SOM_PATH)/package/lrd/externals/summit-rcm/summit_rcm/plugins/chrony
SUMMIT_RCM_CHRONY_PLUGIN_SITE_METHOD = local
SUMMIT_RCM_CHRONY_PLUGIN_SETUP_TYPE = setuptools
SUMMIT_RCM_CHRONY_PLUGIN_DEPENDENCIES = python3 summit-rcm

ifeq ($(BR2_PACKAGE_HOST_PYTHON_CYTHON),y)
SUMMIT_RCM_CHRONY_PLUGIN_DEPENDENCIES += host-python-cython
endif

SUMMIT_RCM_CHRONY_PLUGIN_EXTRA_PACKAGES = \
	summit_rcm_chrony \
	summit_rcm_chrony/services

ifeq ($(BR2_PACKAGE_SUMMIT_RCM_AT_INTERFACE),y)
	SUMMIT_RCM_CHRONY_PLUGIN_EXTRA_PACKAGES += summit_rcm_chrony/at_interface/commands
endif
ifeq ($(BR2_PACKAGE_SUMMIT_RCM_REST_API_V2_ROUTES),y)
    SUMMIT_RCM_CHRONY_PLUGIN_EXTRA_PACKAGES += summit_rcm_chrony/rest_api/v2/system
endif
ifeq ($(BR2_PACKAGE_SUMMIT_RCM_REST_API_LEGACY_ROUTES),y)
    SUMMIT_RCM_CHRONY_PLUGIN_EXTRA_PACKAGES += summit_rcm_chrony/rest_api/legacy
endif

ifeq ($(BR2_PACKAGE_SUMMIT_RCM_REST_API_DOCS),y)
	SUMMIT_RCM_CHRONY_PLUGIN_EXTRA_PACKAGES += summit_rcm_chrony/rest_api/utils/spectree
	SUMMIT_RCM_CHRONY_PLUGIN_DEPENDENCIES += host-summit-rcm-chrony-plugin
	HOST_SUMMIT_RCM_CHRONY_PLUGIN_DEPENDENCIES += \
		host-summit-rcm \
		host-python3 \
		host-python-falcon \
		host-python-spectree \
		host-python-pydantic \
		host-python-typing-extensions
	HOST_SUMMIT_RCM_CHRONY_PLUGIN_ENV = \
		DOCS_GENERATION='True' \
		OPENAPI_JSON_PATH='$(TARGET_DIR)/summit-rcm-openapi-chrony-plugin.json' \
		SUMMIT_RCM_CHRONY_PLUGIN_EXTRA_PACKAGES='$(SUMMIT_RCM_CHRONY_PLUGIN_EXTRA_PACKAGES)'
endif

SUMMIT_RCM_CHRONY_PLUGIN_ENV = SUMMIT_RCM_CHRONY_PLUGIN_EXTRA_PACKAGES='$(SUMMIT_RCM_CHRONY_PLUGIN_EXTRA_PACKAGES)'

$(eval $(python-package))
$(eval $(host-python-package))
