#!/bin/bash
set -e

echo "VMP>>>$0 : varnish"

SCRIPT_DIR=$(cd $(dirname $0); pwd)

rm -rf ${VMP_ROOT_DIR}/pkg
cp -rpL ${VMP_VARNISH_ORG_DIR}/pkg-varnish-cache/arch ${VMP_ROOT_DIR}/pkg/

RELEASE=-1

if [ -n "${VMP_VARNISH_SRC}" ]; then
    VERSION=$(date +%Y%m%d).${VMP_HASH:0:7}
elif [ "${VMP_VARNISH_VER}" = "trunk" ]; then
    VERSION=$(date +%Y%m%d).${VMP_HASH:0:7}
else
    VERSION=${VMP_VARNISH_VER}
fi

sed -i -e "s|@VERSION@|${VERSION}|"  "${VMP_ROOT_DIR}/pkg/PKGBUILD"

cd ${VMP_ROOT_DIR}/pkg

su builder -c "makepkg -rsf --noconfirm --skipinteg"

mkdir -p ${VMP_ROOT_DIR}/pkgs/arch/varnish

cp ${VMP_ROOT_DIR}/pkg/varnish*${VERSION}*.zst ${VMP_ROOT_DIR}/pkgs/arch/varnish/
