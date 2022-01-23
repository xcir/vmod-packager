#!/bin/sh
echo "VMP>>>$0 : ${VMP_VMOD_NAME}"


SCRIPT_DIR=$(cd $(dirname $0); pwd)
rm -rf ${VMP_WORK_DIR}
mkdir ${VMP_WORK_DIR}
cp -rp ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME} ${VMP_WORK_DIR}/src
if [ -e ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_config.sh ]; then
    cp ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_config.sh ${VMP_WORK_DIR}/src/__vmod-package_config.sh
else
    cp ${VMP_ROOT_DIR}/script/default/default_config.sh  ${VMP_WORK_DIR}/src/__vmod-package_config.sh
fi
${VMP_ROOT_DIR}/tplt/debian/pkg.sh
