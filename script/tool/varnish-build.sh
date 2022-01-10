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

if which dpkg &>/dev/null; then
    export VMP_PKGTYPE=deb
elif which rpm &> /dev/null; then
    export VMP_PKGTYPE=rpm
else
    echo "Error: varnish builds aren't supported for other packages than deb and rpm"
    exit 1
fi

${VMP_ROOT_DIR}/script/${VMP_PKGTYPE}/${VMP_PKGTYPE}-varnish-build.sh
