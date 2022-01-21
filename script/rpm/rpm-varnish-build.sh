#!/bin/bash
echo "VMP>>>$0 : varnish"

SCRIPT_DIR=$(cd $(dirname $0); pwd)

cp -rp ${VMP_VARNISH_ORG_DIR}/pkg-varnish-cache/redhat/* ${VMP_ROOT_DIR}/src/

ln -s ${VMP_VARNISH_ORG_DIR}/pkg-varnish-cache/systemd ${VMP_ROOT_DIR}/systemd

# resolve all the symlinks
sed -i '' `find ${VMP_ROOT_DIR}/src/ -maxdepth 1 -type l`

mkdir -p ${VMP_WORK_DIR}/SOURCES
cd ${VMP_ROOT_DIR}

tar cfz ${VMP_WORK_DIR}/SOURCES/src.tgz src



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

rpmbuild \
    --define "_topdir ${VMP_WORK_DIR}" \
    --define "_smp_mflags -j10" \
    --define "versiontag ${VERSION}" \
    --define "releasetag 1${DEBVERSION}" \
    --define "srcname src" \
    --define "nocheck 1" \
    -ba ${VMP_ROOT_DIR}/src/varnish.spec

if [ $? -ne 0 ]; then
    echo "error" 1>&2
    exit 1
fi

mkdir ${VMP_ROOT_DIR}/pkgs/rpms/varnish 2>/dev/null

find ${VMP_WORK_DIR} -type f -name varnish-${VERSION}*.rpm          | xargs -i cp -p {} ${VMP_ROOT_DIR}/pkgs/rpms/varnish/
find ${VMP_WORK_DIR} -type f -name varnish-devel-${VERSION}*.rpm    | xargs -i cp -p {} ${VMP_ROOT_DIR}/pkgs/rpms/varnish/

find ${VMP_WORK_DIR} -type f -name varnish-${VERSION}*.rpm          | awk -F/ '{print "pkgs/rpms/varnish/" $NF}' >> ${VMP_ROOT_DIR}/tmp/vmp_varnish.log
find ${VMP_WORK_DIR} -type f -name varnish-devel-${VERSION}*.rpm    | awk -F/ '{print "pkgs/rpms/varnish/" $NF}' >> ${VMP_ROOT_DIR}/tmp/vmp_varnish.log
