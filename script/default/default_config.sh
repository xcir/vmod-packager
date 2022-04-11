#!/bin/sh
if [ ! -x ./configure ]; then
    if [ -e ./autogen.sh ]; then
        ./autogen.sh
    else
        ./bootstrap
    fi
fi
./configure $@
