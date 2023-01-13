BUILD_TYPE="${2}"

echo "WB45n POST BUILD script: starting..."

# source the common post build script
. ${BR2_EXTERNAL_LRD_SOM_PATH}/board/post_build_common_legacy.sh "${BUILD_TYPE}"

echo "WB45n POST BUILD script: done."
