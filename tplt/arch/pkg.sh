#!/bin/sh
set -e
echo "VMP>>>$0 : ${VMP_VMOD_NAME}"

SCRIPT_DIR=$(cd $(dirname $0); pwd)

if [ "${VMP_VARNISH_VER}" = "trunk" ]; then
    REQUIRE=$(printf "varnish" "${VMP_REQUIRE_ARCH}")
elif [ ${VMP_FIXED_MODE} -eq 1 ]; then
    REQUIRE=$(printf "'varnish=%s' %s" "${VMP_VARNISH_VER}" "${VMP_REQUIRE_ARCH}")
else
    REQUIRE=$(printf "'varnish >= %s' 'varnish < %s' %s" "${VMP_VARNISH_VER}" "${VMP_VARNISH_VER_NXT}" "${VMP_REQUIRE_ARCH}")
fi

sed ${SCRIPT_DIR}/PKGBUILD \
    -e "s/%VRT%/${VMP_VARNISH_VRT}/g" \
    -e "s/%PFX%/${VMP_VMOD_PFX}/g" \
    -e "s/%VMOD%/${VMP_VMOD_NAME}/g" \
    -e "s/%VER%/${VMP_VMOD_VER}/g" \
    -e "s/%VARNISH_VER%/${VMP_VARNISH_VER}/g" \
    -e "s/%REQUIRE%/${REQUIRE}/g" \
    > ${VMP_WORK_DIR}/PKGBUILD
