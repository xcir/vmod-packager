#!/bin/sh

#https://gitlab.com/uplex/varnish/libvdp-pesi

export VINYLSRC=/tmp/varnish/src
./bootstrap --with-vcache="${VMP_SOFT_DIST_NAME}" "$@"

# <9.0
#./bootstrap
#./configure VARNISHSRC=/tmp/varnish/src $@
