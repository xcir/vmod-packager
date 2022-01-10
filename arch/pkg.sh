#!/bin/sh
set -e
echo "VMP>>>$0 : ${VMP_VMOD_NAME}"

SCRIPT_DIR=$(cd $(dirname $0); pwd)

sed ${SCRIPT_DIR}/PKGBUILD \
    -e "s/%VRT%/${VMP_VARNISH_VRT}/g" \
    -e "s/%PFX%/${VMP_VMOD_PFX}/g" \
    -e "s/%VMOD%/${VMP_VMOD_NAME}/g" \
    -e "s/%VER%/${VMP_VMOD_VER}/g" \
    -e "s/%VARNISH_VER%/${VMP_VARNISH_VER}/g" \
    -e "s/%REQUIRE%/${VMP_REQUIRE_RPM}/g" \
    > ${VMP_WORK_DIR}/PKGBUILD
