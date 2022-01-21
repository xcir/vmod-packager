#!/bin/sh
set -e

echo "VMP>>>$0 : ${VMP_VMOD_NAME}"

if [ ${VMP_SKIP_TEST} -eq 1 ]; then
    TMP_TEST="--nocheck"
else
    TMP_TEST=""
fi

cd ${VMP_WORK_DIR}

chown builder -R .
su builder -c "makepkg --force --noconfirm --nodeps --skipinteg $TMP_TEST"

mkdir -p ${VMP_ROOT_DIR}/pkgs/arch/${VMP_VMOD_NAME}
cp *.tar.zst ${VMP_ROOT_DIR}/pkgs/arch/${VMP_VMOD_NAME}/
ls *.tar.zst | awk -F/ "{print \"pkgs/arch/${VMP_VMOD_NAME}/\" \$NF}" >> ${VMP_ROOT_DIR}/tmp/vmp_vmod.log