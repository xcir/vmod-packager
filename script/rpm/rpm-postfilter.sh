#!/bin/sh
cd ${VMP_WORK_DIR}
tar cfz ${VMP_WORK_DIR}/SOURCES/vmod.tar.gz src

rpmbuild --define "_topdir ${VMP_WORK_DIR}" -ba __vmod-package.spec 

mkdir ${VMP_VARNISH_DIR}/pkgs/rpms/${VMP_VMOD_NAME}
find ${VMP_WORK_DIR} -type f -name *.rpm|xargs -i cp -p {} ${VMP_VARNISH_DIR}/pkgs/rpms/${VMP_VMOD_NAME}/
