#!/bin/sh

#https://github.com/varnish/libvmod-digest

export VMP_REQUIRE_DEB=libmhash2
export VMP_REQUIRE_RPM=mhash

export VMP_RPM_ONLY_INC_VMOD=1
export VMP_RPM_DISABLE_UNPACKAGED_TRACK=1
