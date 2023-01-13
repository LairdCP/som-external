ifneq ($(BR2_LRD_DEVEL_BUILD),y)

SUMMIT_SUPPLICANT_BINARIES_VERSION = $(call qstrip,$(BR2_PACKAGE_LRD_RADIO_STACK_VERSION_VALUE))
SUMMIT_SUPPLICANT_BINARIES_SOURCE =
SUMMIT_SUPPLICANT_BINARIES_LICENSE = BSD-3-Clause
# This is needed for libnl to be brought into staging for sdcsdk users
SUMMIT_SUPPLICANT_BINARIES_DEPENDENCIES = libnl
SUMMIT_SUPPLICANT_BINARIES_INSTALL_STAGING = YES

SUMMIT_SUPPLICANT_BINARIES_SUFFIX = $(call qstrip,$(BR2_PACKAGE_SUMMIT_SUPPLICANT_BINARIES_SUFFIX)$(BR2_PACKAGE_LRD_RADIO_STACK_ARCH))
SUMMIT_SUPPLICANT_BINARIES_EXTRA_DOWNLOADS = summit_supplicant$(SUMMIT_SUPPLICANT_BINARIES_SUFFIX)-$(SUMMIT_SUPPLICANT_BINARIES_VERSION).tar.bz2

ifeq ($(MSD_BINARIES_SOURCE_LOCATION),laird_internal)
SUMMIT_SUPPLICANT_BINARIES_SITE = https://files.devops.rfpros.com/builds/linux/summit_supplicant/laird/$(SUMMIT_SUPPLICANT_BINARIES_VERSION)
else
SUMMIT_SUPPLICANT_BINARIES_SITE = https://github.com/LairdCP/wb-package-archive/releases/download/LRD-REL-$(SUMMIT_SUPPLICANT_BINARIES_VERSION)
endif

define SUMMIT_SUPPLICANT_BINARIES_INSTALL_TARGET_CMDS
	tar -xjf $($(PKG)_DL_DIR)/$(SUMMIT_SUPPLICANT_BINARIES_EXTRA_DOWNLOADS) -C $(TARGET_DIR) --keep-directory-symlink --no-overwrite-dir --touch --exclude=usr/include --exclude=usr/lib/libsdc_sdk.so
endef

define SUMMIT_SUPPLICANT_BINARIES_INSTALL_STAGING_CMDS
	tar -xjf $($(PKG)_DL_DIR)/$(SUMMIT_SUPPLICANT_BINARIES_EXTRA_DOWNLOADS) -C $(STAGING_DIR) --keep-directory-symlink --no-overwrite-dir --touch --wildcards usr/include usr/lib/lib*
endef

endif

$(eval $(generic-package))
