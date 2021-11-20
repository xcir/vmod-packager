#!/bin/sh
echo "postfilter"
cd ${VMP_WORK_DIR}/src
mkdir ${VMP_ROOT_DIR}/pkgs/debs/${VMP_VMOD_NAME}
debuild -us -uc -b
cp ../${VMP_VMOD_NAME}* ${VMP_ROOT_DIR}/pkgs/debs/${VMP_VMOD_NAME}/
