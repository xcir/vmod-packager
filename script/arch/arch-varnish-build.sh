#!/bin/bash
set -e

echo "VMP>>>$0 : varnish"

SCRIPT_DIR=$(cd $(dirname $0); pwd)

rm -rf ${VMP_ROOT_DIR}/pkg
cp -rpL ${VMP_PKG_VARNISH_DIR}/arch ${VMP_ROOT_DIR}/pkg/
cp ${VMP_ROOT_DIR}/src/${VMP_SOFT_DIST_NAME}-*.tar.gz ${VMP_ROOT_DIR}/pkg/src.tgz

RELEASE=-1

if [ -n "${VMP_VARNISH_SRC}" ]; then
    VERSION=$(date +%Y%m%d).${VMP_HASH:0:7}
elif [ "${VMP_VARNISH_VER}" = "trunk" ]; then
    VERSION=$(date +%Y%m%d).${VMP_HASH:0:7}
else
    VERSION=${VMP_VARNISH_VER}
fi

if [ ${VMP_SOFT_DIST_NAME} = "vinyl" ]; then
    SOFTNAME="vinyl-cache"
else
    SOFTNAME="varnish"
fi

sed -i \
    -e "s|@VERSION@|${VERSION}|" \
    -e "s|cd \"${SOFTNAME}-$pkgver\"|cd ${SOFTNAME}-*|" \
    -e 's|^source=.*|source=(src.tgz|' \
    "${VMP_ROOT_DIR}/pkg/PKGBUILD"
cd ${VMP_ROOT_DIR}/pkg

if [ ${VMP_SKIP_TEST} -eq 1 ]; then
    TMP_TEST="--nocheck"
else
    TMP_TEST=""
fi

su builder -c "makepkg -rsf --noconfirm --skipinteg ${TMP_TEST}"

mkdir -p ${VMP_ROOT_DIR}/pkgs/arch/${VMP_SOFT_DIST_NAME}

cp ${VMP_ROOT_DIR}/pkg/${VMP_SOFT_DIST_NAME}*.zst ${VMP_ROOT_DIR}/pkgs/arch/${VMP_SOFT_DIST_NAME}/
ls ${VMP_ROOT_DIR}/pkg/${VMP_SOFT_DIST_NAME}*.zst | awk -F/ '{print "pkgs/arch/'"${VMP_SOFT_DIST_NAME}"'/" $NF}' >> ${VMP_ROOT_DIR}/tmp/vmp_varnish.log
