#####################################################################
# Summit Remote Control Manager (RCM)
#####################################################################

SUMMIT_RCM_VERSION = local
SUMMIT_RCM_SITE = $(BR2_EXTERNAL_LRD_SOM_PATH)/package/lrd/externals/summit-rcm
SUMMIT_RCM_SITE_METHOD = local
SUMMIT_RCM_SETUP_TYPE = setuptools
SUMMIT_RCM_DEPENDENCIES = openssl python3

ifeq ($(BR2_PACKAGE_HOST_PYTHON_CYTHON),y)
SUMMIT_RCM_DEPENDENCIES += host-python-cython
endif

SUMMIT_RCM_DEFAULT_USERNAME = $(call qstrip,$(BR2_PACKAGE_SUMMIT_RCM_DEFAULT_USERNAME))
SUMMIT_RCM_DEFAULT_PASSWORD = $(call qstrip,$(BR2_PACKAGE_SUMMIT_RCM_DEFAULT_PASSWORD))
SUMMIT_RCM_SERIAL_PORT = $(call qstrip,$(BR2_PACKAGE_SUMMIT_RCM_SERIAL_PORT))

ifeq ($(BR2_PACKAGE_SUMMIT_RCM),y)
ifeq ($(BR2_PACKAGE_SUMMIT_RCM_REST_API_V2_ROUTES)$(BR2_PACKAGE_SUMMIT_RCM_REST_API_LEGACY_ROUTES)$(BR2_PACKAGE_SUMMIT_RCM_AT_INTERFACE),)
$(error At least one interface (REST API or AT command) must be specified for Summit RCM)
endif
endif

ifeq ($(BR2_PACKAGE_SUMMIT_RCM_REST_API_V2_ROUTES),y)
	SUMMIT_RCM_EXTRA_PACKAGES += \
		summit_rcm/rest_api/v2/system \
		summit_rcm/rest_api/v2/network
ifeq ($(BR2_PACKAGE_SUMMIT_RCM_ENABLE_SESSIONS),y)
	SUMMIT_RCM_EXTRA_PACKAGES += summit_rcm/rest_api/v2/login
endif
endif

ifeq ($(BR2_PACKAGE_SUMMIT_RCM_REST_API_LEGACY_ROUTES),y)
	SUMMIT_RCM_EXTRA_PACKAGES += summit_rcm/rest_api/legacy
endif

ifneq ($(BR2_PACKAGE_SUMMIT_RCM_REST_API_V2_ROUTES)$(BR2_PACKAGE_SUMMIT_RCM_REST_API_LEGACY_ROUTES),)
	SUMMIT_RCM_EXTRA_PACKAGES += summit_rcm/rest_api/services

endif

ifeq ($(BR2_PACKAGE_SUMMIT_RCM_AT_INTERFACE),y)
	SUMMIT_RCM_EXTRA_PACKAGES += \
		summit_rcm/at_interface \
		summit_rcm/at_interface/commands \
		summit_rcm/at_interface/services
endif

SUMMIT_RCM_EXTRA_PACKAGES += summit_rcm/services

SUMMIT_RCM_ENV = SUMMIT_RCM_EXTRA_PACKAGES='$(SUMMIT_RCM_EXTRA_PACKAGES)'

define SUMMIT_RCM_POST_INSTALL_TARGET_HOOK_CMDS
	$(INSTALL) -d $(TARGET_DIR)/etc/summit-rcm

	$(INSTALL) -D -t $(TARGET_DIR)/etc -m 644 $(@D)/summit-rcm.ini

	$(INSTALL) -D -t $(TARGET_DIR)/etc/summit-rcm/ssl -m 644 \
		$(BR2_EXTERNAL_LRD_SOM_PATH)/board/configs-common/keys/rest-server/server.key \
		$(BR2_EXTERNAL_LRD_SOM_PATH)/board/configs-common/keys/rest-server/server.crt \
		$(BR2_EXTERNAL_LRD_SOM_PATH)/board/configs-common/keys/rest-server/ca.crt

	$(INSTALL) -D -m 755 -t $(TARGET_DIR)/sbin $(SUMMIT_RCM_PKGDIR)factory_powerup_summit-rcm.sh

	$(SED) '/^default_/d' $(TARGET_DIR)/etc/summit-rcm.ini
	$(SED) '/\[summit-rcm\]/a default_password: \"$(SUMMIT_RCM_DEFAULT_PASSWORD)\"' $(TARGET_DIR)/etc/summit-rcm.ini
	$(SED) '/\[summit-rcm\]/a default_username: \"$(SUMMIT_RCM_DEFAULT_USERNAME)\"' $(TARGET_DIR)/etc/summit-rcm.ini

	$(SED) '/^managed_software_devices/d' $(TARGET_DIR)/etc/summit-rcm.ini
	$(SED) '/\[summit-rcm\]/a managed_software_devices: $(BR2_PACKAGE_SUMMIT_RCM_MANAGED_SOFTWARE_DEVICES)' $(TARGET_DIR)/etc/summit-rcm.ini

	$(SED) '/^unmanaged_hardware_devices/d' $(TARGET_DIR)/etc/summit-rcm.ini
	$(SED) '/\[summit-rcm\]/a unmanaged_hardware_devices: $(BR2_PACKAGE_SUMMIT_RCM_UNMANAGED_HARDWARE_DEVICES)' $(TARGET_DIR)/etc/summit-rcm.ini

	$(SED) '/^allow_multiple_user_sessions/d' $(TARGET_DIR)/etc/summit-rcm.ini
	$(SED) '/\[summit-rcm\]/a allow_multiple_user_sessions: \
		$(if $(findstring y,$(BR2_PACKAGE_SUMMIT_RCM_ALLOW_MUTLIPLE_USER_SESSIONS)),True,False)' $(TARGET_DIR)/etc/summit-rcm.ini

	$(SED) 's,^tools.sessions.on:.*,tools.sessions.on: \
		$(if $(findstring y,$(BR2_PACKAGE_SUMMIT_RCM_ENABLE_SESSIONS)),True,False),' $(TARGET_DIR)/etc/summit-rcm.ini

	$(SED) '/^enable_client_auth/d' $(TARGET_DIR)/etc/summit-rcm.ini
	$(SED) '/\[summit-rcm\]/a enable_client_auth: \
		$(if $(findstring y,$(BR2_PACKAGE_SUMMIT_RCM_ENABLE_CLIENT_AUTHENTICATION)),True,False)' $(TARGET_DIR)/etc/summit-rcm.ini

	$(SED) '/^disable_certificate_expiry_verification/d' $(TARGET_DIR)/etc/summit-rcm.ini
	$(SED) '/\[summit-rcm\]/a disable_certificate_expiry_verification: \
		$(if $(findstring y,$(BR2_PACKAGE_SUMMIT_RCM_DISABLE_CERTIFICATE_EXPIRY_VERIFICATION)),True,False)' $(TARGET_DIR)/etc/summit-rcm.ini

	$(SED) '/\[summit-rcm\]/a serial_port: \"$(SUMMIT_RCM_SERIAL_PORT)\"' $(TARGET_DIR)/etc/summit-rcm.ini
	$(SED) '/\[summit-rcm\]/a baud_rate: $(BR2_PACKAGE_SUMMIT_RCM_BAUD_RATE)' $(TARGET_DIR)/etc/summit-rcm.ini
	$(SED) '/\[summit-rcm\]/a socket_port: $(BR2_PACKAGE_SUMMIT_RCM_HTTPS_PORT)' $(TARGET_DIR)/etc/summit-rcm.ini

	$(SED) '/^rest_api_docs/d' $(TARGET_DIR)/etc/summit-rcm.ini
	$(SED) '/\[summit-rcm\]/a rest_api_docs: \
		$(if $(findstring y,$(BR2_PACKAGE_SUMMIT_RCM_REST_API_DOCS)),True,False)' $(TARGET_DIR)/etc/summit-rcm.ini
	$(SED) '/^rest_api_docs_root_redirect/d' $(TARGET_DIR)/etc/summit-rcm.ini
	$(SED) '/\[summit-rcm\]/a rest_api_docs_root_redirect: \
		$(if $(findstring y,$(BR2_PACKAGE_SUMMIT_RCM_REST_API_DOCS_ROOT_REDIRECT)),True,False)' $(TARGET_DIR)/etc/summit-rcm.ini

	$(SED) '/^rest_api_validate_request/d' $(TARGET_DIR)/etc/summit-rcm.ini
	$(SED) '/\[summit-rcm\]/a rest_api_validate_request: \
		$(if $(findstring y,$(BR2_PACKAGE_SUMMIT_RCM_REST_API_VALIDATE_REQUEST)),True,False)' $(TARGET_DIR)/etc/summit-rcm.ini
	$(SED) '/^rest_api_validate_response/d' $(TARGET_DIR)/etc/summit-rcm.ini
	$(SED) '/\[summit-rcm\]/a rest_api_validate_response: \
		$(if $(findstring y,$(BR2_PACKAGE_SUMMIT_RCM_REST_API_VALIDATE_RESPONSE)),True,False)' $(TARGET_DIR)/etc/summit-rcm.ini
endef

SUMMIT_RCM_POST_INSTALL_TARGET_HOOKS += SUMMIT_RCM_POST_INSTALL_TARGET_HOOK_CMDS

define SUMMIT_RCM_TARGET_FINALIZE_HOOK_CMDS
	$(HOST_DIR)/bin/python3 $(SUMMIT_RCM_PKGDIR)/merge_api_spec_docs.py \
		"$(TARGET_DIR)" \
		"$(TARGET_DIR)/etc/summit-rcm-openapi.json"

	rm -rf $(TARGET_DIR)/summit-rcm-openapi*.json
endef

ifeq ($(BR2_PACKAGE_SUMMIT_RCM_REST_API_DOCS),y)
	SUMMIT_RCM_EXTRA_PACKAGES += summit_rcm/rest_api/utils/spectree
	SUMMIT_RCM_DEPENDENCIES += host-summit-rcm
	HOST_SUMMIT_RCM_DEPENDENCIES += \
		host-python3 \
		host-python-falcon \
		host-python-spectree \
		host-python-pydantic \
		host-python-typing-extensions
	HOST_SUMMIT_RCM_ENV = \
		DOCS_GENERATION='True' \
		OPENAPI_JSON_PATH='$(TARGET_DIR)/summit-rcm-openapi.json' \
		SUMMIT_RCM_EXTRA_PACKAGES='$(SUMMIT_RCM_EXTRA_PACKAGES)'
	SUMMIT_RCM_TARGET_FINALIZE_HOOKS += SUMMIT_RCM_TARGET_FINALIZE_HOOK_CMDS
endif

define SUMMIT_RCM_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -t $(TARGET_DIR)/usr/lib/systemd/system -m 644 $(@D)/summit-rcm.service
endef

$(eval $(python-package))
$(eval $(host-python-package))
