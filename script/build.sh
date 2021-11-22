#!/bin/bash
echo "VMP>>>$0 : ${VMP_VMOD_NAME}"

SCRIPT_DIR=$(cd $(dirname $0); pwd)

if [ -e ${VMP_ROOT_DIR}/vmod/src/${VMP_VMOD_NAME}_env.sh ]; then
    echo "VMP>>>${VMP_ROOT_DIR}/vmod/src/${VMP_VMOD_NAME}_env.sh : ${VMP_VMOD_NAME}"
    source ${VMP_ROOT_DIR}/vmod/src/${VMP_VMOD_NAME}_env.sh
    if [ $? -ne 0 ]; then
        echo "Error"
        exit 1
    fi
    if [ -n "${VMP_REQUIRE_DEB}" ]; then
        export VMP_REQUIRE_DEB=", ${VMP_REQUIRE_DEB}"
    fi
    if [ -n "${VMP_REQUIRE_RPM}" ]; then
        export VMP_REQUIRE_RPM=", ${VMP_REQUIRE_RPM}"
    fi
fi

which dpkg 2>/dev/null
if [ $? -eq 0 ]; then
    export VMP_PKGTYPE=deb
    ${SCRIPT_DIR}/deb/deb-build.sh
else
    export VMP_PKGTYPE=rpm
    ${SCRIPT_DIR}/rpm/rpm-build.sh
fi

