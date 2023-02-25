################################################################################
#
# lrd-linux-backports
#
################################################################################

ifneq ($(BR2_PACKAGE_LINUX_BACKPORTS_VERSION),)
LRD_LINUX_BACKPORTS_VERSION = $(call qstrip,$(BR2_PACKAGE_LINUX_BACKPORTS_VERSION))
else ifneq ($(BR2_LRD_DEVEL_BUILD),)
LRD_LINUX_BACKPORTS_VERSION = 0.$(BR2_LRD_BRANCH).0.0
else
LRD_LINUX_BACKPORTS_VERSION = $(call qstrip,$(BR2_PACKAGE_LRD_RADIO_STACK_VERSION_VALUE))
endif

LRD_LINUX_BACKPORTS_SOURCE = backports-laird-$(LRD_LINUX_BACKPORTS_VERSION).tar.bz2
BR_NO_CHECK_HASH_FOR += $(LRD_LINUX_BACKPORTS_SOURCE)

ifeq ($(MSD_BINARIES_SOURCE_LOCATION),laird_internal)
LRD_LINUX_BACKPORTS_SITE = https://files.devops.rfpros.com/builds/linux/backports/laird/$(LRD_LINUX_BACKPORTS_VERSION)
else
LRD_LINUX_BACKPORTS_SITE = https://github.com/LairdCP/wb-package-archive/releases/download/LRD-REL-$(LRD_LINUX_BACKPORTS_VERSION)
endif

LRD_LINUX_BACKPORTS_LICENSE = GPL-2.0
LRD_LINUX_BACKPORTS_LICENSE_FILES = \
	COPYING \
	LICENSES/exceptions/Linux-syscall-note \
	LICENSES/preferred/GPL-2.0

# flex and bison are needed to generate kconfig parser. We use the
# same logic as the linux kernel (we add host dependencies only if
# host does not have them). See linux/linux.mk and
# support/dependencies/check-host-bison-flex.mk.
LRD_LINUX_BACKPORTS_KCONFIG_DEPENDENCIES = \
	$(BR2_BISON_HOST_DEPENDENCY) \
	$(BR2_FLEX_HOST_DEPENDENCY)

ifeq ($(BR2_PACKAGE_LRD_LINUX_BACKPORTS_USE_DEFCONFIG),y)
LRD_LINUX_BACKPORTS_KCONFIG_FILE = $(LRD_LINUX_BACKPORTS_DIR)/defconfigs/$(call qstrip,$(BR2_PACKAGE_LRD_LINUX_BACKPORTS_DEFCONFIG))
else ifeq ($(BR2_PACKAGE_LRD_LINUX_BACKPORTS_USE_CUSTOM_CONFIG),y)
LRD_LINUX_BACKPORTS_KCONFIG_FILE = $(call qstrip,$(BR2_PACKAGE_LRD_LINUX_BACKPORTS_CUSTOM_CONFIG_FILE))
endif

LRD_LINUX_BACKPORTS_KCONFIG_FRAGMENT_FILES = $(call qstrip,$(BR2_PACKAGE_LRD_LINUX_BACKPORTS_CONFIG_FRAGMENT_FILES))
LRD_LINUX_BACKPORTS_KCONFIG_OPTS = $(LRD_LINUX_BACKPORTS_MAKE_OPTS)

LRD_LINUX_BACKPORTS_MAKE_ENV = $(HOST_MAKE_ENV)

# linux-backports' build system expects the config options to be present
# in the environment, and it is so when using their custom buildsystem,
# because they are set in the main Makefile, which then calls a second
# Makefile.
#
# In our case, we do not use that first Makefile. So, we parse the
# .config file, filter-out comment lines and put the rest as command
# line variables.
#
# LRD_LINUX_BACKPORTS_MAKE_OPTS is used by the kconfig-package infra, while
# LRD_LINUX_BACKPORTS_MODULE_MAKE_OPTS is used by the kernel-module infra.
#
LRD_LINUX_BACKPORTS_MAKE_OPTS = \
	LEX=flex \
	YACC=bison \
	BACKPORT_DIR=$(@D) \
	KLIB_BUILD=$(LINUX_DIR) \
	KLIB=$(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED) \
	INSTALL_MOD_DIR=updates \
	`sed -r -e '/^\#/d;' $(@D)/.config`

LRD_LINUX_BACKPORTS_MODULE_MAKE_OPTS = $(LRD_LINUX_BACKPORTS_MAKE_OPTS)

# This file is not automatically generated by 'oldconfig' that we use in
# the kconfig-package infrastructure. In the linux buildsystem, it is
# generated by running silentoldconfig, but that's not the case for
# linux-backports: it uses a hand-crafted rule to generate that file.
define LRD_LINUX_BACKPORTS_KCONFIG_FIXUP_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(LRD_LINUX_BACKPORTS_MAKE_OPTS) backport-include/backport/autoconf.h
endef

# Checks to give errors that the user can understand
ifeq ($(BR_BUILDING),y)

ifeq ($(BR2_PACKAGE_LRD_LINUX_BACKPORTS_USE_DEFCONFIG),y)
ifeq ($(call qstrip,$(BR2_PACKAGE_LRD_LINUX_BACKPORTS_DEFCONFIG)),)
$(error No linux-backports defconfig name specified, check your BR2_PACKAGE_LRD_LINUX_BACKPORTS_DEFCONFIG setting)
endif
endif

ifeq ($(BR2_PACKAGE_LRD_LINUX_BACKPORTS_USE_CUSTOM_CONFIG),y)
ifeq ($(call qstrip,$(BR2_PACKAGE_LRD_LINUX_BACKPORTS_CUSTOM_CONFIG_FILE)),)
$(error No linux-backports configuration file specified, check your BR2_PACKAGE_LRD_LINUX_BACKPORTS_CUSTOM_CONFIG_FILE setting)
endif
endif

endif # BR_BUILDING

$(eval $(kernel-module))
$(eval $(kconfig-package))

# linux-backports' own .config file needs options from the kernel's own
# .config file. The dependencies handling in the infrastructure does not
# allow to express this kind of dependencies. Besides, linux.mk might
# not have been parsed yet, so the Linux build dir LINUX_DIR is not yet
# known. Thus, we use a "secondary expansion" so the rule is re-evaluated
# after all Makefiles are parsed, and thus at that time we will have the
# LINUX_DIR variable set to the proper value. Moreover, since linux-4.19,
# the kernel's build system internally touches its .config file, so we
# can't use it as a stamp file. We use the LINUX_KCONFIG_STAMP_DOTCONFIG
# instead.
#
# Furthermore, we want to check the kernel version, since linux-backports
# only supports kernels >= 3.10. To avoid overriding linux-backports'
# KCONFIG_STAMP_DOTCONFIG rule defined in the kconfig-package infra, we
# use an intermediate stamp-file.
#
# Finally, it must also come after the call to kconfig-package, so we get
# LRD_LINUX_BACKPORTS_DIR properly defined (because the target part of the
# rule is not re-evaluated).
#
$(LRD_LINUX_BACKPORTS_DIR)/$(LRD_LINUX_BACKPORTS_KCONFIG_STAMP_DOTCONFIG): $(LRD_LINUX_BACKPORTS_DIR)/.stamp_check_kernel_version

.SECONDEXPANSION:
$(LRD_LINUX_BACKPORTS_DIR)/.stamp_check_kernel_version: $$(LINUX_DIR)/$$(LINUX_KCONFIG_STAMP_DOTCONFIG) linux
	$(Q)KVER=$(LINUX_VERSION_PROBED); \
	KVER_MAJOR=`echo $${KVER} | sed 's/^\([0-9]*\)\..*/\1/'`; \
	KVER_MINOR=`echo $${KVER} | sed 's/^[0-9]*\.\([0-9]*\).*/\1/'`; \
	if [ $${KVER_MAJOR} -lt 3 -o \( $${KVER_MAJOR} -eq 3 -a $${KVER_MINOR} -lt 0 \) ]; then \
		printf "Linux version '%s' is too old for lrd-linux-backports (needs 3.0 or later)\n" \
			"$${KVER}"; \
		exit 1; \
	fi
	$(Q)touch $(@)
