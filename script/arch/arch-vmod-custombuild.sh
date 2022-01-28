#!/bin/bash
echo "VMP>>>$0 : vmod custom"

set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)


${VMP_ROOT_DIR}/tplt/arch/pkg.sh

cp -rp ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME} ${VMP_WORK_DIR}/src


if [ -e ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_build.sh ]; then
    echo "VMP>>>${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_build.sh : ${VMP_VMOD_NAME}"
    ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_build.sh
else
    echo "VMP>>>${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}/vmp_config/${VMP_VMOD_NAME}_build.sh : ${VMP_VMOD_NAME}"
    ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}/vmp_config/${VMP_VMOD_NAME}_build.sh
fi

set -x
(
    cd ${VMP_WORK_DIR}/vmp_build
    tar cvzf ${VMP_WORK_DIR}/src.tgz ./
)

cd ${VMP_WORK_DIR}

chown builder -R .
su builder -c "makepkg --force --noconfirm --nodeps --skipinteg --nocheck"

mkdir -p ${VMP_ROOT_DIR}/pkgs/arch/${VMP_VMOD_NAME}
cp *.tar.zst ${VMP_ROOT_DIR}/pkgs/arch/${VMP_VMOD_NAME}/
ls *.tar.zst | awk -F/ "{print \"pkgs/arch/${VMP_VMOD_NAME}/\" \$NF}" >> ${VMP_ROOT_DIR}/tmp/vmp_vmod.log

