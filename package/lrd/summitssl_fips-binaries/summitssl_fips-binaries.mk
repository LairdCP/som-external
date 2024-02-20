###############################################################################
#
# Summit SSL 1.0.2 FIPS binaries
#
# this package is selected through buildroot/packages/openssl
#
################################################################################

SUMMITSSL_FIPS_BINARIES_CVE_PRODUCT = libopenssl
SUMMITSSL_FIPS_BINARIES_CVE_VERSION = 1.0.2u
SUMMITSSL_FIPS_BINARIES_INSTALL_STAGING = YES

SUMMITSSL_FIPS_BINARIES_PROVIDES = openssl
SUMMITSSL_FIPS_BINARIES_CPE_ID_VENDOR = $(SUMMITSSL_FIPS_BINARIES_PROVIDES)
SUMMITSSL_FIPS_BINARIES_CPE_ID_PRODUCT = $(SUMMITSSL_FIPS_BINARIES_PROVIDES)

SUMMITSSL_FIPS_BINARIES_PREFIX = laird_openssl_fips
SUMMITSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2020-1968
SUMMITSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2020-1971
SUMMITSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2021-23840
SUMMITSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2021-23841
SUMMITSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2021-23839
SUMMITSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2021-3712
SUMMITSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2022-1292
SUMMITSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2022-2068

SUMMITSSL_FIPS_BINARIES_VERSION = $(call qstrip,$(BR2_PACKAGE_SUMMITSSL_FIPS_BINARIES_VERSION_VALUE))

SUMMITSSL_FIPS_BINARIES_SOURCE =
SUMMITSSL_FIPS_BINARIES_LICENSE = OpenSSL or SSLeay
SUMMITSSL_FIPS_BINARIES_EXTRA_DOWNLOADS = $(SUMMITSSL_FIPS_BINARIES_PREFIX)$(call qstrip,$(BR2_PACKAGE_LRD_RADIO_STACK_ARCH))-$(SUMMITSSL_FIPS_BINARIES_VERSION).tar.bz2

ifeq ($(MSD_BINARIES_SOURCE_LOCATION),laird_internal)
  SUMMITSSL_FIPS_BINARIES_SITE = https://files.devops.rfpros.com/builds/linux/laird_openssl_fips/$(SUMMITSSL_FIPS_BINARIES_VERSION)
else
  SUMMITSSL_FIPS_BINARIES_SITE = https://github.com/LairdCP/wb-package-archive/releases/download/LRD-REL-$(SUMMITSSL_FIPS_BINARIES_VERSION)
endif

ifeq ($(BR2_PACKAGE_LIBOPENSSL_BIN),)
define SUMMITSSL_FIPS_BINARIES_REMOVE_BIN
	$(RM) -f $(TARGET_DIR)/usr/bin/openssl
	$(RM) -f $(TARGET_DIR)/etc/ssl/misc/{CA.*,c_*}
endef
endif

define SUMMITSSL_FIPS_BINARIES_INSTALL_STAGING_CMDS
	tar -xjvf $($(PKG)_DL_DIR)/$(SUMMITSSL_FIPS_BINARIES_EXTRA_DOWNLOADS) -C $(STAGING_DIR) --keep-directory-symlink --no-overwrite-dir --touch --strip-components=1 staging
endef

define SUMMITSSL_FIPS_BINARIES_INSTALL_TARGET_CMDS
	tar -xjvf $($(PKG)_DL_DIR)/$(SUMMITSSL_FIPS_BINARIES_EXTRA_DOWNLOADS) -C $(TARGET_DIR) --keep-directory-symlink --no-overwrite-dir --touch --strip-components=1 target
	$(SUMMITSSL_FIPS_BINARIES_REMOVE_BIN)
endef

$(eval $(generic-package))
