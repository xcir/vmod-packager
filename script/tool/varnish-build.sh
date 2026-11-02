#!/bin/bash
set -e
echo "VMP>>>$0 : varnish"

if [ ! -d "${VMP_PKG_VARNISH_DIR}" ]; then
    echo "None ${VMP_PKG_VARNISH_DIR}"
    exit 1
fi

# https://github.com/varnishcache/varnish-cache/wiki/Release-procedure
# `make dist` required to build doc
cd ${VMP_ROOT_DIR}/src

if [ ! -d "${VMP_ROOT_DIR}/src/doc/html" ]; then
    mkdir -p ${VMP_ROOT_DIR}/src/doc/html
fi
make dist

# Build native packages from the distribution archive. Cleaning the build tree
# can remove distributed inputs which a release archive cannot regenerate
# (for example Vinyl 9.1's bundled VTest version.h).
export VMP_CACHE_DIST="${VMP_ROOT_DIR}/cache-source.tar.gz"
cp "${VMP_CACHE_PKG_NAME}"-*.tar.gz "${VMP_CACHE_DIST}"
mkdir -p "${VMP_ROOT_DIR}/cache-source"
tar zxf "${VMP_CACHE_DIST}" -C "${VMP_ROOT_DIR}/cache-source" --strip-components 1
cd "${VMP_ROOT_DIR}"
rm -rf "${VMP_ROOT_DIR}/src"
mv "${VMP_ROOT_DIR}/cache-source" "${VMP_ROOT_DIR}/src"

rm -rf ${VMP_ROOT_DIR}/systemd
cp -rp ${VMP_PKG_VARNISH_DIR}/systemd ${VMP_ROOT_DIR}/



${VMP_ROOT_DIR}/script/${VMP_PKGTYPE}/${VMP_PKGTYPE}-varnish-build.sh
