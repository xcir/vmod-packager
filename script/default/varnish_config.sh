#!/bin/sh
set -e

# Match the library directory used by the native RPM package build.
if which rpm >/dev/null 2>&1; then
    exec ./configure --prefix=/usr --libdir="$(rpm --eval '%{_libdir}')" "$@"
else
    exec ./configure --prefix=/usr "$@"
fi
