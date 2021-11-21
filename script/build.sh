#!/bin/bash
SCRIPT_DIR=$(cd $(dirname $0); pwd)
which dpkg 2>/dev/null

if [ -e ${VMP_ROOT_DIR}/vmod/src/${VMP_VMOD_NAME}_env.sh ]; then
    source ${VMP_ROOT_DIR}/vmod/src/${VMP_VMOD_NAME}_env.sh
    if [ -n "${VMP_REQUIRE_DEB}" ]; then
        export VMP_REQUIRE_DEB=", ${VMP_REQUIRE_DEB}"
    fi
    if [ -n "${VMP_REQUIRE_RPM}" ]; then
        export VMP_REQUIRE_RPM=", ${VMP_REQUIRE_RPM}"
    fi
fi

if [ $? -eq 0 ]; then
    export VMP_PKGTYPE=deb
    ${SCRIPT_DIR}/deb/deb-build.sh
else
    export VMP_PKGTYPE=rpm
    ${SCRIPT_DIR}/rpm/rpm-build.sh
fi

