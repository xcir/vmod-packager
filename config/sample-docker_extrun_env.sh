#!/bin/sh
export VMP_DOCKER_EXTRUN_focal="
    apt-get install --no-install-recommends -yq clang && 
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rust.sh &&
    /bin/sh /tmp/rust.sh -y && rm /tmp/rust.sh
    "
