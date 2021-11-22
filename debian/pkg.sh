#!/bin/sh
echo "VMP>>>$0 : ${VMP_VMOD_NAME}"

SCRIPT_DIR=$(cd $(dirname $0); pwd)
CN=`lsb_release -cs`
rm -rf ${VMP_WORK_DIR}/src/debian
mkdir ${VMP_WORK_DIR}/src/debian
if [ ${VMP_SKIP_TEST} -eq 1 ]; then
    TMP_TEST="override_dh_auto_test:"
else
    TMP_TEST=""
fi

for i in `find ${SCRIPT_DIR}/tpl/ -type f`; do
    cat ${i} \
     | sed -r "s/%CN%/${CN}/g" \
     | sed -r "s/%VRT%/${VMP_VARNISH_VRT}/g" \
     | sed -r "s/%PFX%/${VMP_VMOD_PFX}/g" \
     | sed -r "s/%VMOD%/${VMP_VMOD_NAME}/g" \
     | sed -r "s/%VER%/${VMP_VMOD_VER}/g" \
     | sed -r "s/%REQUIRE%/${VMP_REQUIRE_DEB}/g" \
     | sed -r "s/%VARNISH_VER%/${VMP_VARNISH_VER}/g" \
     | sed -r "s/%VARNISH_VER_NXT%/${VMP_VARNISH_VER_NXT}/g" \
     | sed -r "s/%TEST%/${TMP_TEST}/g" \
     > ${VMP_WORK_DIR}/src/debian/`basename ${i}`

done
if [ ${VMP_VARNISH_VRT} -eq 999 ]; then
    cp ${VMP_ROOT_DIR}/work/src/debian/control.trunk ${VMP_WORK_DIR}/src/debian/control
elif [ ${VMP_FIXED_MODE} -eq 1 ]; then
    cp ${VMP_ROOT_DIR}/work/src/debian/control.fixed ${VMP_WORK_DIR}/src/debian/control
fi
#CN   = CodeName
#VRT  = Varnish VRT Version
#VMOD = VMOD Name
#VER  = VMOD Version