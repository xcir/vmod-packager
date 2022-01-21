#!/bin/sh
echo "VMP>>>$0 : ${VMP_VMOD_NAME}"


cd ${VMP_WORK_DIR}
tar cfz ${VMP_WORK_DIR}/SOURCES/vmod.tar.gz src

rpmbuild \
    --define "_topdir ${VMP_WORK_DIR}" \
    -ba __vmod-package.spec

if [ $? -ne 0 ]; then
    echo "Error" 1>&2
    exit 1
fi
mkdir ${VMP_ROOT_DIR}/pkgs/rpms/${VMP_VMOD_NAME}  2>/dev/null
find ${VMP_WORK_DIR} -type f -name *.rpm | xargs -i cp -p {} ${VMP_ROOT_DIR}/pkgs/rpms/${VMP_VMOD_NAME}/

find ${VMP_WORK_DIR} -type f -name *.rpm | awk -F/ "{print \"pkgs/rpms/${VMP_VMOD_NAME}/\" \$NF}" >> ${VMP_ROOT_DIR}/tmp/vmp_vmod.log
