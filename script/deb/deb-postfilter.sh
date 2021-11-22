#!/bin/sh
echo "VMP>>>$0 : ${VMP_VMOD_NAME}"


cd ${VMP_WORK_DIR}/src
mkdir ${VMP_ROOT_DIR}/pkgs/debs/${VMP_VMOD_NAME} 2>/dev/null
debuild -us -uc -b
if [ $? -ne 0 ]; then
    cp ../${VMP_VMOD_PFX}${VMP_VMOD_NAME}* ${VMP_ROOT_DIR}/pkgs/debs/${VMP_VMOD_NAME}/
    echo "Error"
    exit 1
else
    cp ../${VMP_VMOD_PFX}${VMP_VMOD_NAME}* ${VMP_ROOT_DIR}/pkgs/debs/${VMP_VMOD_NAME}/
fi