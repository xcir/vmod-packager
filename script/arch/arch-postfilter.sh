#!/bin/sh
set -e

echo "VMP>>>$0 : ${VMP_VMOD_NAME}"

cd ${VMP_WORK_DIR}
set -x
chown builder -R .
su builder -c "makepkg --force --geninteg" >> PKGBUILD
su builder -c "makepkg --force --noconfirm --nodeps "

mkdir -p ${VMP_ROOT_DIR}/pkgs/arch/${VMP_VMOD_NAME}
find ${VMP_WORK_DIR} -type f -name *.tar.zst | xargs -i cp -p {} ${VMP_ROOT_DIR}/pkgs/arch/${VMP_VMOD_NAME}/
