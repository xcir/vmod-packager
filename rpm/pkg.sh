#!/bin/sh
SCRIPT_DIR=$(cd $(dirname $0); pwd)

if [ ${VMP_VARNISH_VRT} -eq 999 ]; then
    SFX=.trunk
elif [ ${VMP_FIXED_MODE} -eq 1 ]; then
    SFX=.fixed
fi

if [ ${VMP_SKIP_TEST} -eq 1 ]; then
    TMP_TEST="echo"
else
    TMP_TEST="make check"
fi

cat ${SCRIPT_DIR}/tplt.spec${SFX} \
    | sed -r "s/%VRT%/${VMP_VARNISH_VRT}/g" \
    | sed -r "s/%PFX%/${VMP_VMOD_PFX}/g" \
    | sed -r "s/%VMOD%/${VMP_VMOD_NAME}/g" \
    | sed -r "s/%VER%/${VMP_VMOD_VER}/g" \
    | sed -r "s/%REQ%/${VMP_REQUIRE_RPM}/g" \
    | sed -r "s/%VARNISH_VER%/${VMP_VARNISH_VER}/g" \
    | sed -r "s/%VARNISH_VER_NXT%/${VMP_VARNISH_VER_NXT}/g" \
    | sed -r "s/%TEST%/${TMP_TEST}/g" \
    > ${VMP_WORK_DIR}/__vmod-package.spec

