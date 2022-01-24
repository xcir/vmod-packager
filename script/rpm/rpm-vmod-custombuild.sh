#!/bin/bash
echo "VMP>>>$0 : vmod custom"

set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)


${VMP_ROOT_DIR}/tplt/rpm/pkg.sh


echo "VMP>>>${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_build.sh : ${VMP_VMOD_NAME}"
${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_build.sh

cd ${VMP_WORK_DIR}
mkdir -p ${VMP_WORK_DIR}/SOURCES

tar cfz ${VMP_WORK_DIR}/SOURCES/vmod.tar.gz vmp_build/

rpmbuild \
    --define "_topdir ${VMP_WORK_DIR}" \
    -ba __vmod-package.spec

mkdir -p ${VMP_ROOT_DIR}/pkgs/rpms/${VMP_VMOD_NAME} 
find ${VMP_WORK_DIR} -type f -name *.rpm | xargs -i cp -p {} ${VMP_ROOT_DIR}/pkgs/rpms/${VMP_VMOD_NAME}/

find ${VMP_WORK_DIR} -type f -name *.rpm | awk -F/ "{print \"pkgs/rpms/${VMP_VMOD_NAME}/\" \$NF}" >> ${VMP_ROOT_DIR}/tmp/vmp_vmod.log
