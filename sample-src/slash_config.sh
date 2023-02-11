#!/bin/sh

#https://code.uplex.de/uplex-varnish/slash/tree/master

./bootstrap
./configure VARNISHSRC=/tmp/varnish/src $@
