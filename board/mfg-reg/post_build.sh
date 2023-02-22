# enable tracing and exit on errors
set -x -e

BR2_LRD_PRODUCT="$(sed -n 's,^BR2_DEFCONFIG=".*/\(.*\)_defconfig"$,\1,p' ${BR2_CONFIG})"

echo "${BR2_LRD_PRODUCT^^} POST BUILD script: starting..."

if [ -f ${TARGET_DIR}/usr/lib/libedit.so ]; then
LIBEDIT=$(readlink ${TARGET_DIR}/usr/lib/libedit.so)
LIBEDITLRD=${LIBEDIT/libedit./libedit.lrd.}
cp "${TARGET_DIR}/usr/lib/${LIBEDIT}" "${TARGET_DIR}/usr/lib/${LIBEDITLRD}"
fi

if [ -f ${TARGET_DIR}/usr/lib/libncurses.so ]; then
LIBNCURSES=$(readlink ${TARGET_DIR}/usr/lib/libncurses.so)
LIBNCURSESLRD=${LIBNCURSES/libncurses./libncurses.lrd.}
cp "${TARGET_DIR}/usr/lib/${LIBNCURSES}" "${TARGET_DIR}/usr/lib/${LIBNCURSESLRD}"
fi

add_file() {
	for var in "${@}"; do
		[ -f "${TARGET_DIR}${var}" ] && \
			echo ${var} >> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"
	done
}

add_firmware() {
	add_file $(ls ${1} | sed "s,^${TARGET_DIR},,")
}

rm -f ${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest

case "${BR2_LRD_PRODUCT}" in
mfg60*)
	#lrt and other vendor mfg tools are mutually exclusive
	[ -f ${TARGET_DIR}/usr/bin/lrt ] &&  exit 0

	add_file \
		/usr/bin/lmu \
		/usr/bin/lru \
		/usr/bin/btlru \
		/usr/lib/${LIBEDITLRD} \
		/usr/lib/${LIBNCURSESLRD}

	add_firmware  "${TARGET_DIR}/lib/firmware/lrdmwl/88W8997_mfg_*"
	;;

reg45*)
	add_file \
		/usr/bin/lru \
		/usr/sbin/smu_cli \
		/usr/bin/tcmd.sh \
		/usr/lib/${LIBEDITLRD} \
		/usr/lib/${LIBNCURSESLRD}

	add_firmware "${TARGET_DIR}/lib/firmware/ath6k/AR6003/hw2.1.1/athtcmd*"

	# move tcmd.sh into package and add to manifest
	cp ${BR2_EXTERNAL_LRD_SOM_PATH}/board/mfg-reg/rootfs-additions/tcmd.sh ${TARGET_DIR}/usr/bin
	;;

reg50*)
	add_file \
		/usr/bin/lru \
		/usr/sbin/smu_cli \
		/usr/bin/tcmd.sh \
		/usr/lib/${LIBEDITLRD} \
		/usr/lib/${LIBNCURSESLRD}

	add_firmware "${TARGET_DIR}/lib/firmware/ath6k/AR6004/hw3.0/utf*"

	# move tcmd.sh into package and add to manifest
	cp ${BR2_EXTERNAL_LRD_SOM_PATH}/board/mfg-reg/rootfs-additions/tcmd.sh ${TARGET_DIR}/usr/bin
	;;

regCypress*)
	add_file /usr/bin/wl
	add_firmware "${TARGET_DIR}/lib/firmware/brcm/brcmfmac4339-sdio-mfg_*.bin"
	add_firmware "${TARGET_DIR}/lib/firmware/brcm/brcmfmac43430-sdio-mfg_*.bin"
	;;

regLWB5plus*)
	add_file \
		/usr/bin/lru \
		/usr/bin/btlru \
		/lib/firmware/brcm/brcmfmac4373-div-mfg.txt \
		/usr/lib/${LIBEDITLRD} \
		/usr/lib/${LIBNCURSESLRD}

	add_firmware "${TARGET_DIR}/lib/firmware/brcm/brcmfmac4373-*-mfg_*.bin"
	;;

regLWBplus*)
	add_file \
		/usr/bin/lru \
		/usr/bin/btlru \
		/usr/lib/${LIBEDITLRD} \
		/usr/lib/${LIBNCURSESLRD}

	add_firmware "${TARGET_DIR}/lib/firmware/brcm/brcmfmac43439-sdio-mfg_*.bin"
	;;

regLWB6*)
	add_file \
		/usr/bin/lru \
		/usr/bin/btlru \
		/usr/lib/${LIBEDITLRD} \
		/usr/lib/${LIBNCURSESLRD}

	add_firmware "${TARGET_DIR}/lib/firmware/cypress/cyfmac55572-*-mfg_*.trxse"
	;;

*)
	exit 1
	;;
esac

# make sure board script is not in target directory and copy it from rootfs-additions
cp ${BR2_EXTERNAL_LRD_SOM_PATH}/board/mfg-reg/rootfs-additions/reg_tools.sh ${TARGET_DIR}

echo "${BR2_LRD_PRODUCT^^} POST BUILD script: done."
