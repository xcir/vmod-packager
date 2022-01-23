#!/bin/sh
set -e

echo "VMP>>>$0 : ${VMP_VMOD_NAME}"

SCRIPT_DIR=$(cd $(dirname $0); pwd)
rm -rf ${VMP_WORK_DIR}
mkdir -p ${VMP_WORK_DIR}

set -x
(
    cd ${VMP_VMOD_ORG_SRC_DIR}
    tar cvzf ${VMP_WORK_DIR}/src.tgz ${VMP_VMOD_NAME}
)

if [ -e ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_config.sh ]; then
    cp ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_config.sh ${VMP_WORK_DIR}/__vmod-package_config.sh
else
    cp ${VMP_ROOT_DIR}/script/default/default_config.sh  ${VMP_WORK_DIR}/__vmod-package_config.sh
fi

${VMP_ROOT_DIR}/tplt/arch/pkg.sh
