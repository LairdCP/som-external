BUILD_TYPE="${2}"

echo "WB50n POST IMAGE script: starting..."

# source the common post image script
. ${BR2_EXTERNAL_LRD_SOM_PATH}/board/post_image_common.sh "${BUILD_TYPE}"

echo "WB50n POST IMAGE script: done."
