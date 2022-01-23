#!/bin/bash
set -e

echo "VMP>>>$0 : VMOD Custom build"

SCRIPT_DIR=$(cd $(dirname $0); pwd)
rm -rf ${VMP_WORK_DIR}
mkdir ${VMP_WORK_DIR}
cp -rp ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME} ${VMP_WORK_DIR}/src
mkdir -p ${VMP_WORK_DIR}/vmp_build/usr/lib/varnish/vmods/

echo "VMP>>>${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_build.sh : ${VMP_VMOD_NAME}"
${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_build.sh

${VMP_ROOT_DIR}/tplt/debian/pkg.sh
cp -rp ${VMP_WORK_DIR}/src/debian ${VMP_WORK_DIR}/vmp_build/debian

cp ${VMP_WORK_DIR}/vmp_build/debian/rules.custombuild ${VMP_WORK_DIR}/vmp_build/debian/rules
cp ${VMP_WORK_DIR}/vmp_build/debian/install.custombuild ${VMP_WORK_DIR}/vmp_build/debian/install

cd ${VMP_WORK_DIR}/vmp_build/

mkdir -p ${VMP_ROOT_DIR}/pkgs/debs/${VMP_VMOD_NAME}

debuild -us -uc -b


ls ../${VMP_VMOD_PFX}${VMP_VMOD_NAME}* | awk -F/ "{print \"pkgs/debs/${VMP_VMOD_NAME}/\" \$NF}" >> ${VMP_ROOT_DIR}/tmp/vmp_vmod.log
cp ../${VMP_VMOD_PFX}${VMP_VMOD_NAME}* ${VMP_ROOT_DIR}/pkgs/debs/${VMP_VMOD_NAME}/

# todo
# depends support
