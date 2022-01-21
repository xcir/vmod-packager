#!/bin/bash
echo "VMP>>>$0 : varnish"

SCRIPT_DIR=$(cd $(dirname $0); pwd)


rm -rf ${VMP_ROOT_DIR}/src/debian

cp -rp ${VMP_VARNISH_ORG_DIR}/pkg-varnish-cache/debian ${VMP_ROOT_DIR}/src/
ln -s ${VMP_VARNISH_ORG_DIR}/pkg-varnish-cache/systemd ${VMP_ROOT_DIR}/src/systemd

# resolve all the symlinks
sed -i '' ${VMP_ROOT_DIR}/src/debian/varnish*

RELEASE=-1
DEBVERSION="vmp"

if [ -n "${VMP_VARNISH_SRC}" ]; then
    VERSION=$(date +%Y%m%d).${VMP_HASH:0:7}
    DEBVERSION="vmp+fromsrc"
elif [ "${VMP_VARNISH_VER}" = "trunk" ]; then
    VERSION=$(date +%Y%m%d).${VMP_HASH:0:7}
    DEBVERSION="vmp+trunk"
else
    VERSION=${VMP_VARNISH_VER}
fi
CN=`lsb_release -cs`
FULL_VERSION="${VERSION}-1${DEBVERSION}~${CN}"
sed -i -e "s|@VERSION@|${FULL_VERSION}|"  "${VMP_ROOT_DIR}/src/debian/changelog"

cd ${VMP_ROOT_DIR}/src

debuild -us -uc -b
if [ $? -ne 0 ]; then
    echo "error" 1>&2
    exit 1
fi

mkdir ${VMP_ROOT_DIR}/pkgs/debs/varnish 2>/dev/null

cp ${VMP_ROOT_DIR}/varnish*${FULL_VERSION}* ${VMP_ROOT_DIR}/pkgs/debs/varnish/
ls ${VMP_ROOT_DIR}/varnish*${FULL_VERSION}* | awk -F/ '{print "pkgs/debs/varnish/" $NF}' >> ${VMP_ROOT_DIR}/tmp/vmp_varnish.log
