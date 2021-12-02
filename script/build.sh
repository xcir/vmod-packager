#!/bin/bash
echo "VMP>>>$0 : ${VMP_VMOD_NAME}"

SCRIPT_DIR=$(cd $(dirname $0); pwd)

if [ -n "${VMP_VARNISH_SRC}" ]; then
    cp -rp ${VMP_VARNISH_ORG_DIR}/${VMP_VARNISH_SRC} ${VMP_ROOT_DIR}/src
    cd ${VMP_ROOT_DIR}/src
    ./autogen.sh && \
    ./configure --prefix=/usr && \
    make -sj32 && \
    make install
    if [ $? -ne 0 ]; then
        echo "Varnish build error" 1>&2
        exit 1
    fi
fi
# ref https://github.com/varnishcache/pkg-varnish-cache/blob/master/debian/rules
export VMP_VARNISH_VRT=`printf '#include "/tmp/varnish/src/include/vdef.h"\n#include "/tmp/varnish/src/include/vrt.h"\n%s.%s\' VRT_MAJOR_VERSION VRT_MINOR_VERSION|  cpp - -Iinclude|tail -1|tr -c -d '[0-9]'`
echo ${VMP_VARNISH_VRT} > ${VMP_ROOT_DIR}/tmp/vrt
if [ ${VMP_VARNISH_VRT} -lt 10 ]; then
    echo "Error: Could not get VRT" 1>&2
    exit 1
fi


if [ -e ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_env.sh ]; then
    echo "VMP>>>${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_env.sh : ${VMP_VMOD_NAME}"
    source ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_env.sh
    if [ $? -ne 0 ]; then
        echo "Error" 1>&2
        exit 1
    fi
    if [ -n "${VMP_REQUIRE_DEB}" ]; then
        export VMP_REQUIRE_DEB=", ${VMP_REQUIRE_DEB}"
    fi
    if [ -n "${VMP_REQUIRE_RPM}" ]; then
        export VMP_REQUIRE_RPM=", ${VMP_REQUIRE_RPM}"
    fi
fi



if [ ${VMP_VARNISH_PKG_MODE} -eq 1 ]; then
    ${SCRIPT_DIR}/tool/varnish-build.sh
    if [ $? -ne 0 ]; then
        echo "Error" 1>&2
        exit 1
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

