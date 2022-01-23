#!/bin/sh
echo "VMP>>>$0 : ${VMP_VMOD_NAME}"

SCRIPT_DIR=$(cd $(dirname $0); pwd)

if [ "${VMP_VARNISH_VER}" = "trunk" ]; then
    SFX=.trunk
elif [ ${VMP_FIXED_MODE} -eq 1 ]; then
    SFX=.fixed
fi

if [ "${VMP_RPM_ONLY_INC_VMOD}" = "1" ]; then
    TMP_MAN=""
    TMP_DATADIR=""
else
    TMP_MAN="%{_mandir}\/*"
    TMP_DATADIR="%{_datadir}\/*"
fi

if [ "${VMP_RPM_DISABLE_UNPACKAGED_TRACK}" = "1" ]; then
    TMP_UNPAC="%define _unpackaged_files_terminate_build 0"
else
    TMP_UNPAC=" "
fi

if [ ${VMP_SKIP_TEST} -eq 1 ]; then
    TMP_TEST="echo"
else
    TMP_TEST="make check"
fi

TMP_TIME=`date +"%a %b %d %Y"`

sed ${SCRIPT_DIR}/tplt.spec${SFX} \
    -e "s/%VRT%/${VMP_VARNISH_VRT}/g" \
    -e "s/%PFX%/${VMP_VMOD_PFX}/g" \
    -e "s/%VMOD%/${VMP_VMOD_NAME}/g" \
    -e "s/%VER%/${VMP_VMOD_VER}/g" \
    -e "s/%REQUIRE%/${VMP_REQUIRE_RPM}/g" \
    -e "s/%VARNISH_VER%/${VMP_VARNISH_VER}/g" \
    -e "s/%VARNISH_VER_NXT%/${VMP_VARNISH_VER_NXT}/g" \
    -e "s/%TEST%/${TMP_TEST}/g" \
    -e "s/%FILES_MAN%/${TMP_MAN}/g" \
    -e "s/%FILES_DATADIR%/${TMP_DATADIR}/g" \
    -e "s/%UNPACKAGED_TRACK%/${TMP_UNPAC}/g" \
    -e "s/%TIME%/${TMP_TIME}/g" \
    > ${VMP_WORK_DIR}/__vmod-package.spec



