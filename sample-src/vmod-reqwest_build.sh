#!/bin/bash
# https://github.com/gquintard/vmod_reqwest
set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)

source ~/.cargo/env
if [ "${VMP_PKGTYPE}" = "deb" ]; then
    apt-get update
    apt-get -yq install libssl-dev
elif [ "${VMP_PKGTYPE}" = "rpm" ]; then
    dnf -y install openssl-devel
#elif [ "${VMP_PKGTYPE}" = "arch" ]; then
fi

cd ${VMP_WORK_DIR}/src
cargo build --release
cp ${VMP_WORK_DIR}/src/target/release/*.so ${VMP_WORK_DIR}/vmp_build/usr/lib/varnish/vmods/

