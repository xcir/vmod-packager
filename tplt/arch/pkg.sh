#!/bin/sh
set -e
echo "VMP>>>$0 : ${VMP_VMOD_NAME}"

SCRIPT_DIR=$(cd $(dirname $0); pwd)

if [ "${VMP_VARNISH_VER}" = "trunk" ]; then
    REQUIRE=$(printf "varnish %s" "${VMP_REQUIRE_ARCH}")
elif [ ${VMP_FIXED_MODE} -eq 1 ]; then
    REQUIRE=$(printf "'varnish=%s' %s" "${VMP_VARNISH_VER}" "${VMP_REQUIRE_ARCH}")
else
    REQUIRE=$(printf "'varnish>=%s' 'varnish<%s' %s" "${VMP_VARNISH_VER}" "${VMP_VARNISH_VER_NXT}" "${VMP_REQUIRE_ARCH}")
fi

if [ ${VMP_VMOD_CUSTOM_BUILD} -eq 1 ]; then
    SFX=".custombuild"
fi

sed ${SCRIPT_DIR}/PKGBUILD${SFX} \
    -e "s/%VRT%/${VMP_VARNISH_VRT}/g" \
    -e "s/%PFX%/${VMP_VMOD_PFX}/g" \
    -e "s/%VMOD%/${VMP_VMOD_NAME}/g" \
    -e "s/%VER%/${VMP_VMOD_VER}/g" \
    -e "s/%DESC%/${VMP_DESC}/g" \
    -e "s/%VARNISH_VER%/${VMP_VARNISH_VER}/g" \
    -e "s/%REQUIRE%/${REQUIRE}/g" \
    > ${VMP_WORK_DIR}/PKGBUILD
