#!/bin/sh

#https://code.uplex.de/uplex-varnish/slash/tree/master

#Note: If you get an error around io_uring, please check if the host kernel can use io_uring.

if [ "${VMP_PKGTYPE}" = "deb" ]; then
    apt-get update
    apt-get -yq install liburing-dev libxxhash-dev
elif [ "${VMP_PKGTYPE}" = "rpm" ]; then
    dnf -y install liburing-devel xxhash-devel
elif [ "${VMP_PKGTYPE}" = "arch" ]; then
    pacman --noconfirm -Sy liburing xxhash
fi
