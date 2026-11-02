#!/bin/sh
set -e

vmp_configure() {
    if [ -n "${VMP_VTEST_EXT}" ]; then
        "$@" --with-vcache="${VMP_SOFT_DIST_NAME}"
    else
        "$@"
    fi
}

if [ ! -x ./configure ]; then
    if [ -e ./autogen.sh ]; then
        vmp_configure ./autogen.sh "$@"
    else
        vmp_configure ./bootstrap "$@"
    fi
fi
vmp_configure ./configure "$@"
