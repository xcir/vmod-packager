#!/bin/sh

#https://gitlab.com/uplex/varnish/libvdp-pesi

if [ ${VMP_PKGTYPE} != "arch" ]; then
    cp -rp ${VMP_ROOT_DIR}/src/m4 ${VMP_WORK_DIR}/src/m4
fi
