#!/bin/sh
echo "VMP>>>$0 : ${VMP_VMOD_NAME}"


SCRIPT_DIR=$(cd $(dirname $0); pwd)

if [ ${VMP_VARNISH_VRT} -eq 999 ]; then
    SFX=.trunk
elif [ ${VMP_FIXED_MODE} -eq 1 ]; then
    SFX=.fixed
fi

if [ "${VMP_RPM_ONLY_INC_VMOD}" = "1" ]; then
    TMP_MAN=" "
    TMP_DATADIR=" "
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

cat ${SCRIPT_DIR}/tplt.spec${SFX} \
    | sed -r "s/%VRT%/${VMP_VARNISH_VRT}/g" \
    | sed -r "s/%PFX%/${VMP_VMOD_PFX}/g" \
    | sed -r "s/%VMOD%/${VMP_VMOD_NAME}/g" \
    | sed -r "s/%VER%/${VMP_VMOD_VER}/g" \
    | sed -r "s/%REQUIRE%/${VMP_REQUIRE_RPM}/g" \
    | sed -r "s/%VARNISH_VER%/${VMP_VARNISH_VER}/g" \
    | sed -r "s/%VARNISH_VER_NXT%/${VMP_VARNISH_VER_NXT}/g" \
    | sed -r "s/%TEST%/${TMP_TEST}/g" \
    | sed -r "s/%FILES_MAN%/${TMP_MAN}/g" \
    | sed -r "s/%FILES_DATADIR%/${TMP_DATADIR}/g" \
    | sed -r "s/%UNPACKAGED_TRACK%/${TMP_UNPAC}/g" \
    | sed -r "s/%TIME%/${TMP_TIME}/g" \
    > ${VMP_WORK_DIR}/__vmod-package.spec

