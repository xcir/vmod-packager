#!/bin/bash
echo "VMP>>>$0 : varnish"

SCRIPT_DIR=$(cd $(dirname $0); pwd)


rm -rf ${VMP_ROOT_DIR}/src/debian
cp -rp ${VMP_VARNISH_ORG_DIR}/pkg-varnish-cache/debian ${VMP_ROOT_DIR}/src/

#Error when using symlink...
FILES=`find ${VMP_ROOT_DIR}/src/debian/ -maxdepth 1 -type l | awk -F/ '{print $NF}'`
for FILE in $FILES; do
    rm ${VMP_ROOT_DIR}/src/debian/${FILE}
    cp ${VMP_ROOT_DIR}/systemd/${FILE} ${VMP_ROOT_DIR}/src/debian/${FILE}
done

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
