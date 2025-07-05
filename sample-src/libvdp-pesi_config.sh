#!/bin/sh

#https://gitlab.com/uplex/varnish/libvdp-pesi

./bootstrap
./configure VARNISHSRC=/tmp/varnish/src $@
