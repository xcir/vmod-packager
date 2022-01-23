#!/bin/bash
set -e

# https://github.com/gquintard/vmod_reqwest

SCRIPT_DIR=$(cd $(dirname $0); pwd)

source ~/.cargo/env

apt-get install libssl-dev
cd ${VMP_WORK_DIR}/src
cargo build --release
cp ${VMP_WORK_DIR}/src/target/release/libvmod_reqwest.so ${VMP_WORK_DIR}/vmp_build/usr/lib/varnish/vmods/

