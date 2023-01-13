BUILD_TYPE="${2}"

echo "WB50n POST BUILD legacy script: starting..."

# source the common post build legacy script
. ${BR2_EXTERNAL_LRD_SOM_PATH}/board/post_build_common_legacy.sh "${BUILD_TYPE}"

echo "WB50n POST BUILD script: done."
