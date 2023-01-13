ifeq ($(BR2_LRD_DEVEL_BUILD),y)
else
SOM60_FIRMWARE_BINARIES_VERSION = $(call qstrip,$(BR2_PACKAGE_LRD_RADIO_STACK_VERSION_VALUE))
SOM60_FIRMWARE_BINARIES_SOURCE =
SOM60_FIRMWARE_BINARIES_LICENSE = GPL-2.0
SOM60_FIRMWARE_BINARIES_LICENSE_FILES = COPYING
SOM60_FIRMWARE_BINARIES_EXTRA_DOWNLOADS = laird-som60-radio-firmware-$(SOM60_FIRMWARE_BINARIES_VERSION).tar.bz2

ifeq ($(MSD_BINARIES_SOURCE_LOCATION),laird_internal)
  SOM60_FIRMWARE_BINARIES_SITE = https://files.devops.rfpros.com/builds/linux/firmware/$(SOM60_FIRMWARE_BINARIES_VERSION)
else
  SOM60_FIRMWARE_BINARIES_SITE = https://github.com/LairdCP/wb-package-archive/releases/download/LRD-REL-$(SOM60_FIRMWARE_BINARIES_VERSION)
endif

define SOM60_FIRMWARE_BINARIES_SOM60_INSTALL_TARGET
	tar -xjf $($(PKG)_DL_DIR)/laird-som60-radio-firmware-$(SOM60_FIRMWARE_BINARIES_VERSION).tar.bz2 -C $(TARGET_DIR) --keep-directory-symlink --no-overwrite-dir --touch
endef

ifeq ($(BR2_PACKAGE_SOM60_ST_SDIO_UART_FIRMWARE_BINARIES),y)

SOM60_FIRMWARE_BINARIES_EXTRA_DOWNLOADS += laird-sterling60-firmware-sdio-uart-$(SOM60_FIRMWARE_BINARIES_VERSION).tar.bz2

define SOM60_ST_SDIO_UART_FIRMWARE_BINARIES_INSTALL_TARGET
	tar -xjf $($(PKG)_DL_DIR)/laird-sterling60-firmware-sdio-uart-$(SOM60_FIRMWARE_BINARIES_VERSION).tar.bz2 --wildcards -C $(TARGET_DIR) --keep-directory-symlink --no-overwrite-dir --touch */88W8997_*.bin
endef
endif

define SOM60_FIRMWARE_BINARIES_INSTALL_TARGET_CMDS
	$(SOM60_FIRMWARE_BINARIES_SOM60_INSTALL_TARGET)
	$(SOM60_ST_SDIO_UART_FIRMWARE_BINARIES_INSTALL_TARGET)
endef

endif

$(eval $(generic-package))
