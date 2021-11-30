#!/bin/bash
echo "VMP>>>$0 : varnish"

SCRIPT_DIR=$(cd $(dirname $0); pwd)

if [ ! -d "${VMP_ROOT_DIR}/vmod/src/pkg-varnish-cache" ]; then
    echo "None src/pkg-varnish-cache"
    exit 1
fi

if [ ! -d "${VMP_ROOT_DIR}/src/doc/html" ]; then
    mkdir -p ${VMP_ROOT_DIR}/src/doc/html
fi

rm -rf ${VMP_ROOT_DIR}/systemd
cp -rp ${VMP_ROOT_DIR}/vmod/src/pkg-varnish-cache/systemd ${VMP_ROOT_DIR}/

which dpkg 2>/dev/null
if [ $? -eq 0 ]; then
    export VMP_PKGTYPE=deb
    ${SCRIPT_DIR}/deb/deb-varnish-build.sh
else
    export VMP_PKGTYPE=rpm
    ${SCRIPT_DIR}/rpm/rpm-varnish-build.sh
fi
