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
TMP_TIME=`date +"%a, %d %b %Y %H:%M:%S %z"`

if [ "${VMP_VARNISH_VER}" = "trunk" ]; then
    DEPENDS=$(printf '${shlibs:Depends}, ${misc:Depends}, varnish%s' "${VMP_REQUIRE_DEB}")
elif [ ${VMP_FIXED_MODE} -eq 1 ]; then
    DEPENDS=$(printf '${shlibs:Depends}, ${misc:Depends}, varnish (= %s)%s' "${VMP_VARNISH_VER}" "${VMP_REQUIRE_DEB}")
else
    DEPENDS=$(printf '${shlibs:Depends}, ${misc:Depends}, varnish (>= %s), varnish (<< %s)%s' "${VMP_VARNISH_VER}" "${VMP_VARNISH_VER_NXT}" "${VMP_REQUIRE_DEB}")
fi

for i in `find ${SCRIPT_DIR}/tpl/ -type f`; do
    sed $i \
        -e "s/%CN%/${CN}/g" \
        -e "s/%VRT%/${VMP_VARNISH_VRT}/g" \
        -e "s/%PFX%/${VMP_VMOD_PFX}/g" \
        -e "s/%VMOD%/${VMP_VMOD_NAME}/g" \
        -e "s/%VER%/${VMP_VMOD_VER}/g" \
        -e "s/%DESC%/${VMP_DESC}/g" \
        -e "s/%DEPENDS%/${DEPENDS}/g" \
        -e "s/%VARNISH_VER%/${VMP_VARNISH_VER}/g" \
        -e "s/%VARNISH_VER_NXT%/${VMP_VARNISH_VER_NXT}/g" \
        -e "s/%TEST%/${TMP_TEST}/g" \
        -e "s/%TIME%/${TMP_TIME}/g" \
        > ${VMP_WORK_DIR}/src/debian/`basename ${i}`
done

#CN   = CodeName
#VRT  = Varnish VRT Version
#VMOD = VMOD Name
#VER  = VMOD Version

