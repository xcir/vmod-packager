#!/bin/bash
set -e

echo "VMP>>>$0 : VMOD Custom build"

SCRIPT_DIR=$(cd $(dirname $0); pwd)
rm -rf ${VMP_WORK_DIR}
mkdir ${VMP_WORK_DIR}
cp -rp ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME} ${VMP_WORK_DIR}/src

mkdir -p ${VMP_WORK_DIR}/vmp_build/usr/lib/varnish/vmods/
mkdir -p ${VMP_ROOT_DIR}/pkgs/debs/${VMP_VMOD_NAME}

${VMP_ROOT_DIR}/script/${VMP_PKGTYPE}/${VMP_PKGTYPE}-vmod-custombuild.sh

