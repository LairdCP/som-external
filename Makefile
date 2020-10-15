ARCH_all = x86 x86_64 arm-eabi arm-eabihf aarch64 powerpc64-e5500
ARCH_lrd = arm-eabi arm-eabihf

MAKE_TARGETS = $(foreach t,$(TARGETS_COMPONENT_$(1)), $(addprefix $(t)-,$(ARCH_$(1))))

TARGETS = \
	wb50n_legacy wb50n_rdvk wb45n_legacy \
	wb40n_rdvk wb40n_rdvk_3_2 \
	wb50n_sysd wb50nsd_sysd wb50n_sysd_rdvk wb50nsd_sysd-wbx3 \
	som60 som60sd som60sd_mfg som60sd-wbx3 \
	som60x2 som60x2sd som60x2sd_mfg som60x2sd-wbx3 \
	som60_lwb_mfg som60x2_rdvk som60x2_lwb_mfg \
	wb60 wb60sd \
	ig60ll ig60llsd	ig60sd-wbx3 \
	bdimx6_rdvk \
	som60_toolchain wb4x_toolchain

TARGETS_COMPONENT_all = mfg60n \
	summit_supplicant summit_supplicant_openssl_1_0_2 \
	adaptive_ww adaptive_ww_openssl_1_0_2 adaptive_bt

TARGETS_COMPONENT_lrd = reg45n reg50n regCypress regLWB5plus \
	summit_supplicant_legacy summit_supplicant_legacy_fips \
	laird_openssl_fips

TARGETS_COMPONENT = \
	$(call MAKE_TARGETS,all) $(call MAKE_TARGETS,lrd) \
	backports backports-test firmware \
	regCypress-aarch64 regLWB5plus-aarch64 \
	sterling_supplicant-x86 sterling_supplicant-arm \
	summit_supplicant_fips-arm-eabihf

# NOTE, summit_supplicant is *NOT* released as source
TARGETS_SRC = sterling_supplicant-src lrd-network-manager-src adaptive_bt-src linux-docs

#**************************************************************************

MK_DIR = $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
BR_DIR = $(realpath $(MK_DIR)/../buildroot)
CONFIG_DIR = $(BR_DIR)/configs

export BR2_EXTERNAL =

TARGETS_SRC_CLEAN = $(addsuffix -clean, $(TARGETS_SRC))

ifneq ($(BR_DIR),)
include $(BR_DIR)/board/laird/build-rules.mk
else
OUTPUT_DIR ?= $(abspath $(MK_DIR)/../buildroot/output)
endif

all: $(TARGETS_SRC) linux-docs
clean: $(TARGETS_SRC_CLEAN)

LINUX_DOCS_SRC_DIR = $(MK_DIR)/../linux_docs
LINUX_DOCS_DST_DIR = $(OUTPUT_DIR)/linux-docs

ifneq ($(VERSION),)
RELEASE_SUFFIX = -$(VERSION)
endif

linux-docs:
	mkdir -p $(LINUX_DOCS_DST_DIR)/build $(LINUX_DOCS_DST_DIR)/images
	rm -rf $(LINUX_DOCS_DST_DIR)/build/*
	cp -rt $(LINUX_DOCS_DST_DIR)/build $(LINUX_DOCS_SRC_DIR)/60_series \
		$(LINUX_DOCS_SRC_DIR)/LWB $(LINUX_DOCS_SRC_DIR)/latex_templates

	$(MAKE) -C $(LINUX_DOCS_DST_DIR)/build/60_series all
	cd $(LINUX_DOCS_DST_DIR)/build/60_series && \
	tar -cjf $(LINUX_DOCS_DST_DIR)/images/laird-sterling-60-docs$(RELEASE_SUFFIX).tar.bz2 \
		--owner=root --group=root \
		app_note_*.pdf \
		sig_60_series_radio.pdf \
		user_guide_60_networkmanager.pdf \
		user_guide_60_dvk_su60_sipt.pdf

	$(MAKE) -C $(LINUX_DOCS_DST_DIR)/build/LWB all
	tar -cjf $(LINUX_DOCS_DST_DIR)/images/laird-sterling-lwb-docs$(RELEASE_SUFFIX).tar.bz2 \
		-C $(LINUX_DOCS_DST_DIR)/build/LWB \
		--owner=root --group=root \
		imx6_integration_howto.pdf

lrd-network-manager-src:
	mkdir -p $(OUTPUT_DIR)/$@/images
	tar -C $(BR_DIR)/package/lrd/externals/lrd-network-manager --exclude=.git \
		--transform "s,.,lrd-network-manager$(RELEASE_SUFFIX)," \
		--owner=root --group=root \
		-cJf $(OUTPUT_DIR)/$@/images/$@$(RELEASE_SUFFIX).tar.xz .

sterling_supplicant-src:
	mkdir -p $(OUTPUT_DIR)/$@/images
	tar -C $(BR_DIR)/package/lrd/externals/sterling_supplicant --exclude=.git \
		--transform "s,^,sterling_supplicant$(RELEASE_SUFFIX)/," \
		--owner=root --group=root \
		-czf $(OUTPUT_DIR)/$@/images/$@$(RELEASE_SUFFIX).tar.gz \
		README COPYING CONTRIBUTIONS src wpa_supplicant hs20 laird

adaptive_bt-src:
	mkdir -p $(OUTPUT_DIR)/$@/images
	tar -C $(BR_DIR)/package/lrd/externals/adaptive_bt --exclude=.git \
		--transform "s,^,adaptive_bt$(RELEASE_SUFFIX)/," \
		--owner=root --group=root \
		-czf $(OUTPUT_DIR)/$@/images/$@$(RELEASE_SUFFIX).tar.gz \
		Makefile include src support

$(TARGETS_SRC_CLEAN): %-clean:
	rm -rf $(OUTPUT_DIR)/$*

.PHONY: $(TARGETS_SRC) $(TARGETS_SRC_CLEAN)
