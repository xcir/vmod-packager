#!/bin/sh
if [ -e ./autogen.sh ]; then
    ./autogen.sh
else
    ./bootstrap
fi
./configure $@
