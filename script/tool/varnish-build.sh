#!/bin/bash
echo "VMP>>>$0 : varnish"


if [ ! -d "${VMP_VARNISH_ORG_DIR}/pkg-varnish-cache" ]; then
    echo "None ${VMP_VARNISH_ORG_DIR}/pkg-varnish-cache"
    exit 1
fi

# https://github.com/varnishcache/varnish-cache/wiki/Release-procedure
# `make dist`` required to build doc
cd ${VMP_ROOT_DIR}/src
if [ ! -d "${VMP_ROOT_DIR}/src/doc/html" ]; then
    mkdir -p ${VMP_ROOT_DIR}/src/doc/html
fi
make dist
make clean

rm -rf ${VMP_ROOT_DIR}/systemd
cp -rp ${VMP_VARNISH_ORG_DIR}/pkg-varnish-cache/systemd ${VMP_ROOT_DIR}/

which dpkg 2>/dev/null
if [ $? -eq 0 ]; then
    export VMP_PKGTYPE=deb
    ${VMP_ROOT_DIR}/script/deb/deb-varnish-build.sh
else
    export VMP_PKGTYPE=rpm
    ${VMP_ROOT_DIR}/script/rpm/rpm-varnish-build.sh
fi
