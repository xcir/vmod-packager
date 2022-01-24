#!/bin/sh
RUST_DEB="
    apt-get install --no-install-recommends -yq clang && 
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rust.sh &&
    /bin/sh /tmp/rust.sh -y && rm /tmp/rust.sh
    "

RUST_RPM="
    dnf -y install llvm-toolset && 
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rust.sh &&
    /bin/sh /tmp/rust.sh -y && rm /tmp/rust.sh
    "

RUST_ARCH="
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rust.sh &&
    /bin/sh /tmp/rust.sh -y && rm /tmp/rust.sh
    "

export VMP_DOCKER_EXTRUN_focal="${RUST_DEB}"
export VMP_DOCKER_EXTRUN_centos8="${RUST_RPM}"
export VMP_DOCKER_EXTRUN_arch="${RUST_ARCH}"
