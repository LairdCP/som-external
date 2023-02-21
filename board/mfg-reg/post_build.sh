# enable tracing and exit on errors
set -x -e

BR2_LRD_PRODUCT="$(sed -n 's,^BR2_DEFCONFIG=".*/\(.*\)_defconfig"$,\1,p' ${BR2_CONFIG})"

echo "${BR2_LRD_PRODUCT^^} POST BUILD script: starting..."

if [ -f ${TARGET_DIR}/usr/lib/libedit.so ]; then
LIBEDIT=$(readlink ${TARGET_DIR}/usr/lib/libedit.so)
LIBEDITLRD=${LIBEDIT/libedit./libedit.lrd.}
fi

if [ -f ${TARGET_DIR}/usr/lib/libncurses.so ]; then
LIBNCURSES=$(readlink ${TARGET_DIR}/usr/lib/libncurses.so)
LIBNCURSESLRD=${LIBNCURSES/libncurses./libncurses.lrd.}
fi

case "${BR2_LRD_PRODUCT}" in
mfg60*)
	NL=$'\n'
	MANIFEST_FILES=

	#lrt and other vendor mfg tools are mutually exclusive
	[ -f ${TARGET_DIR}/usr/bin/lrt ] &&  exit 0

	if [ -f ${TARGET_DIR}/usr/bin/lmu ]; then
	MANIFEST_FILES="${MANIFEST_FILES}${NL}/usr/bin/lmu"
	fi

	if [ -f ${TARGET_DIR}/usr/bin/lru ]; then
	MANIFEST_FILES="${MANIFEST_FILES}${NL}/usr/bin/lru"
	fi

	if [ -f ${TARGET_DIR}/usr/bin/btlru ]; then
	MANIFEST_FILES="${MANIFEST_FILES}${NL}/usr/bin/btlru"
	fi

	if [ -f ${TARGET_DIR}/usr/lib/libedit.so ]; then
	MANIFEST_FILES="${MANIFEST_FILES}${NL}/usr/lib/${LIBEDITLRD}"
	cp "${TARGET_DIR}/usr/lib/${LIBEDIT}" "${TARGET_DIR}/usr/lib/${LIBEDITLRD}"
	fi

	if [ -f ${TARGET_DIR}/usr/lib/libncurses.so ]; then
	MANIFEST_FILES="${MANIFEST_FILES}${NL}/usr/lib/${LIBNCURSESLRD}"
	cp "${TARGET_DIR}/usr/lib/${LIBNCURSES}" "${TARGET_DIR}/usr/lib/${LIBNCURSESLRD}"
	fi

	echo "${MANIFEST_FILES}" \
	> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"

	ls "${TARGET_DIR}/lib/firmware/lrdmwl/88W8997_mfg_"* | sed "s,^${TARGET_DIR},," \
		>> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"
	;;

reg45*)
	echo "/usr/bin/lru
	/usr/sbin/smu_cli
	/usr/bin/tcmd.sh
	/usr/lib/${LIBEDITLRD}
	/usr/lib/${LIBNCURSESLRD}" \
	> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"

	ls "${TARGET_DIR}/lib/firmware/ath6k/AR6003/hw2.1.1/athtcmd"* | sed "s,^${TARGET_DIR},," \
		>> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"

	cp "${TARGET_DIR}/usr/lib/${LIBEDIT}" "${TARGET_DIR}/usr/lib/${LIBEDITLRD}"
	cp "${TARGET_DIR}/usr/lib/${LIBNCURSES}" "${TARGET_DIR}/usr/lib/${LIBNCURSESLRD}"

	# move tcmd.sh into package and add to manifest
	cp ${BR2_EXTERNAL_LRD_SOM_PATH}/board/mfg-reg/rootfs-additions/tcmd.sh ${TARGET_DIR}/usr/bin
	;;

reg50*)
	echo "/usr/bin/lru
	/usr/sbin/smu_cli
	/usr/bin/tcmd.sh
	/usr/lib/${LIBEDITLRD}
	/usr/lib/${LIBNCURSESLRD}" \
	> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"

	ls "${TARGET_DIR}/lib/firmware/ath6k/AR6004/hw3.0/utf"* | sed "s,^${TARGET_DIR},," \
		>> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"

	cp "${TARGET_DIR}/usr/lib/${LIBEDIT}" "${TARGET_DIR}/usr/lib/${LIBEDITLRD}"
	cp "${TARGET_DIR}/usr/lib/${LIBNCURSES}" "${TARGET_DIR}/usr/lib/${LIBNCURSESLRD}"

	# move tcmd.sh into package and add to manifest
	cp ${BR2_EXTERNAL_LRD_SOM_PATH}/board/mfg-reg/rootfs-additions/tcmd.sh ${TARGET_DIR}/usr/bin
	;;

regCypress*)
	echo "/usr/bin/wl" > "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"

	ls "${TARGET_DIR}/lib/firmware/brcm/brcmfmac4339-sdio-mfg_"*".bin" | sed "s,^${TARGET_DIR},," \
		>> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"
	ls "${TARGET_DIR}/lib/firmware/brcm/brcmfmac43430-sdio-mfg_"*".bin" | sed "s,^${TARGET_DIR},," \
		>> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"
	;;

regLWB5plus*)
	echo "/usr/bin/lru
	/usr/bin/btlru
	/lib/firmware/brcm/brcmfmac4373-div-mfg.txt
	/usr/lib/${LIBEDITLRD}
	/usr/lib/${LIBNCURSESLRD}" \
	> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"

	ls "${TARGET_DIR}/lib/firmware/brcm/brcmfmac4373-"*"-mfg_"*".bin" | sed "s,^${TARGET_DIR},," \
		>> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"

	cp "${TARGET_DIR}/usr/lib/${LIBEDIT}" "${TARGET_DIR}/usr/lib/${LIBEDITLRD}"
	cp "${TARGET_DIR}/usr/lib/${LIBNCURSES}" "${TARGET_DIR}/usr/lib/${LIBNCURSESLRD}"
	;;

regLWBplus*)
	echo "/usr/bin/lru
	/usr/bin/btlru
	/usr/lib/${LIBEDITLRD}
	/usr/lib/${LIBNCURSESLRD}" \
	> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"

	ls "${TARGET_DIR}/lib/firmware/brcm/brcmfmac43439-sdio-mfg_"*".bin" | sed "s,^${TARGET_DIR},," \
		>> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"

	cp "${TARGET_DIR}/usr/lib/${LIBEDIT}" "${TARGET_DIR}/usr/lib/${LIBEDITLRD}"
	cp "${TARGET_DIR}/usr/lib/${LIBNCURSES}" "${TARGET_DIR}/usr/lib/${LIBNCURSESLRD}"
	;;

regLWB6*)
	echo "/usr/bin/lru
	/usr/bin/btlru
	/usr/lib/${LIBEDITLRD}
	/usr/lib/${LIBNCURSESLRD}" \
	> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"

	ls "${TARGET_DIR}/lib/firmware/cypress/cyfmac55572-"*"-mfg_"*".trxse" | sed "s,^${TARGET_DIR},," \
		>> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"

	cp "${TARGET_DIR}/usr/lib/${LIBEDIT}" "${TARGET_DIR}/usr/lib/${LIBEDITLRD}"
	cp "${TARGET_DIR}/usr/lib/${LIBNCURSES}" "${TARGET_DIR}/usr/lib/${LIBNCURSESLRD}"
	;;

*)
	exit 1
	;;
esac

# make sure board script is not in target directory and copy it from rootfs-additions
cp ${BR2_EXTERNAL_LRD_SOM_PATH}/board/mfg-reg/rootfs-additions/reg_tools.sh ${TARGET_DIR}

echo "${BR2_LRD_PRODUCT^^} POST BUILD script: done."
