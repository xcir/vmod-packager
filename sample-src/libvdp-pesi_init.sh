#!/bin/sh

if [ "${VMP_PKGTYPE}" = "deb" ]; then
    apt-get update
    apt-get -yq install zlib1g-dev
elif [ "${VMP_PKGTYPE}" = "rpm" ]; then
    dnf -y install zlib-devel
elif [ "${VMP_PKGTYPE}" = "arch" ]; then
    pacman --noconfirm -Sy zlib
fi
