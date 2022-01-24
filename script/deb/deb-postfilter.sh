#!/bin/sh
echo "VMP>>>$0 : ${VMP_VMOD_NAME}"


cd ${VMP_WORK_DIR}/src
mkdir -p ${VMP_ROOT_DIR}/pkgs/debs/${VMP_VMOD_NAME}

debuild -us -uc -b

if [ $? -ne 0 ]; then
    ls ../${VMP_VMOD_PFX}${VMP_VMOD_NAME}* | awk -F/ "{print \"pkgs/debs/${VMP_VMOD_NAME}/\" \$NF}" >> ${VMP_ROOT_DIR}/tmp/vmp_vmod.log
    cp ../${VMP_VMOD_PFX}${VMP_VMOD_NAME}* ${VMP_ROOT_DIR}/pkgs/debs/${VMP_VMOD_NAME}/
    echo "Error"
    exit 1
else
    ls ../${VMP_VMOD_PFX}${VMP_VMOD_NAME}* | awk -F/ "{print \"pkgs/debs/${VMP_VMOD_NAME}/\" \$NF}" >> ${VMP_ROOT_DIR}/tmp/vmp_vmod.log
    cp ../${VMP_VMOD_PFX}${VMP_VMOD_NAME}* ${VMP_ROOT_DIR}/pkgs/debs/${VMP_VMOD_NAME}/
fi