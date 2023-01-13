# enable tracing and exit on errors
set -x -e

BR2_LRD_PRODUCT="$(sed -n 's,^BR2_DEFCONFIG=".*/\(.*\)_defconfig"$,\1,p' ${BR2_CONFIG})"

echo "${BR2_LRD_PRODUCT^^} POST IMAGE script: starting..."

# wbx3 sd card loading tools
ln -rsf ${BR2_EXTERNAL_LRD_SOM_PATH}/board/scripts-common/mksdcard-wbx3.sh ${BINARIES_DIR}/mksdcard.sh
ln -rsf ${BR2_EXTERNAL_LRD_SOM_PATH}/board/scripts-common/mksdimg-wbx3.sh ${BINARIES_DIR}/mksdimg.sh

[ -z "${VERSION}" ] || RELEASE_SUFFIX="-${VERSION}"

tar -C ${BINARIES_DIR} \
	-chjf ${BINARIES_DIR}/${BR2_LRD_PRODUCT}-laird${RELEASE_SUFFIX}.tar.bz2 \
	--owner=0 --group=0 --numeric-owner \
	u-boot-spl.bin u-boot.itb mksdcard.sh mksdimg.sh

echo "${BR2_LRD_PRODUCT^^} POST IMAGE script: done."
