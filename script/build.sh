#!/bin/sh
SCRIPT_DIR=$(cd $(dirname $0); pwd)
which dpkg
if [ $? -eq 0 ]; then
    export VMP_PKGTYPE=deb
    ${SCRIPT_DIR}/deb/deb-build.sh
else
    export VMP_PKGTYPE=rpm
    ${SCRIPT_DIR}/rpm/rpm-build.sh
fi
