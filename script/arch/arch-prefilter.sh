#!/bin/sh
set -e

echo "VMP>>>$0 : ${VMP_VMOD_NAME}"

SCRIPT_DIR=$(cd $(dirname $0); pwd)
rm -rf ${VMP_WORK_DIR}
mkdir -p ${VMP_WORK_DIR}/tmp/

cp -rp ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME} ${VMP_WORK_DIR}/tmp/
sh "${VMP_ROOT_DIR}/script/tool/vmod-vcacheize.sh" "${VMP_WORK_DIR}/tmp/${VMP_VMOD_NAME}"

set -x
(
    cd ${VMP_WORK_DIR}/tmp/
    tar cvzf ${VMP_WORK_DIR}/src.tgz ${VMP_VMOD_NAME}
)

if [ -e ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_config.sh ]; then
    cp ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_config.sh ${VMP_WORK_DIR}/__vmod-package_config.sh
elif [ -e ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}/vmp_config/${VMP_VMOD_NAME}_config.sh ]; then
    cp ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}/vmp_config/${VMP_VMOD_NAME}_config.sh ${VMP_WORK_DIR}/__vmod-package_config.sh
else
    cp ${VMP_ROOT_DIR}/script/default/default_config.sh  ${VMP_WORK_DIR}/__vmod-package_config.sh
fi

${VMP_ROOT_DIR}/tplt/arch/pkg.sh
