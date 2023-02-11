#!/bin/sh

#https://code.uplex.de/uplex-varnish/slash/tree/master

export VMP_REQUIRE_DEB="liburing, libxxhash"
export VMP_REQUIRE_RPM="liburing, xxhash-libs"
export VMP_REQUIRE_ARCH="liburing xxhash"

#export VMP_RPM_ONLY_INC_VMOD=1
export VMP_RPM_DISABLE_UNPACKAGED_TRACK=1
