#!/bin/bash
set -e

echo "VMP>>>$0 : varnish"

SCRIPT_DIR=$(cd $(dirname $0); pwd)

(
	cd ${VMP_ROOT_DIR}/src/
	tar cfz ${VMP_WORK_DIR}/src.tgz *
)

if [ -n "${VMP_VARNISH_SRC}" ]; then
    VERSION=$(date +%Y%m%d).${VMP_HASH:0:7}
elif [ "${VMP_VARNISH_VER}" = "trunk" ]; then
    VERSION=$(date +%Y%m%d).${VMP_HASH:0:7}
else
    VERSION=${VMP_VARNISH_VER}
fi

# TODO cp all other files
sed ${SCRIPT_DIR}/PKGBUILD \
    -r "s/%VERSION%/$VERSION/" \
    ${VMP_WORK_DIR}/PKGBUILD

(
    cd ${VMP_WORK_DIR}/
    makepkg -g -f -p PKGBUILD
)

mkdir -p ${VMP_ROOT_DIR}/pkgs/arch/varnish
find ${VMP_WORK_DIR} -type f -name varnish-${VERSION}*.zst  -exec cp -p {} ${VMP_ROOT_DIR}/pkgs/arch/varnish/ \;
