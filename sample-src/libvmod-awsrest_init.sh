#!/bin/sh

#https://github.com/xcir/libvmod-awsrest

if [ "${VMP_PKGTYPE}" = "deb" ]; then
    apt-get update
    apt-get -yq install libmhash-dev
elif [ "${VMP_PKGTYPE}" = "rpm" ]; then
    dnf -y install libmhash-devel
elif [ "${VMP_PKGTYPE}" = "arch" ]; then
    pacman -Sy --noconfirm mhash
fi
