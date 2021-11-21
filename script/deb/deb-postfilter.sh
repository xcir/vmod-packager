#!/bin/sh
echo "postfilter"
cd ${VMP_WORK_DIR}/src
mkdir ${VMP_ROOT_DIR}/pkgs/debs/${VMP_VMOD_NAME} 2>/dev/null
debuild -us -uc -b
cp ../${VMP_VMOD_NAME}* ${VMP_ROOT_DIR}/pkgs/debs/${VMP_VMOD_NAME}/
