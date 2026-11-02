#!/bin/sh
set -e

if [ "${VMP_VCACHEIZE:-0}" -ne 1 ]; then
    exit 0
fi

cd "$1"

# The upstream script is in contrib even when built without --with-contrib.
if [ -f "${VMP_ROOT_DIR}/src/contrib/vcacheize" ]; then
    vcacheize="${VMP_ROOT_DIR}/src/contrib/vcacheize"
elif which vcacheize >/dev/null 2>&1; then
    vcacheize=$(which vcacheize)
else
    vcacheize=
fi

if [ -n "${vcacheize}" ]; then
    # Copies retain the source owner's UID. Trust only this working directory
    # for the git commands used by the upstream script.
    config_count=${GIT_CONFIG_COUNT:-0}
    export "GIT_CONFIG_KEY_${config_count}=safe.directory"
    export "GIT_CONFIG_VALUE_${config_count}=${PWD}"
    export GIT_CONFIG_COUNT=$((config_count + 1))
    if [ "$(git rev-parse --show-toplevel 2>/dev/null)" != "${PWD}" ]; then
        echo "Error: vcacheize requires a VMOD Git working tree: ${PWD}" >&2
        exit 1
    fi
    echo "VMP>>>$0 : Run upstream vcacheize for ${VMP_SOFT_DIST_NAME}"
    sh "${vcacheize}" </dev/null
    # Regenerate configure after changing configure.ac, including in trees
    # which already contain an untracked configure from an earlier build.
    if [ -f ./autogen.sh ] || [ -f ./bootstrap ]; then
        rm -f ./configure
    fi
elif [ "${VMP_SOFT_DIST_NAME}" = vinyl ]; then
    # https://vinyl-cache.org/docs/9.0/whats-new/upgrading-9.0.html
    echo "VMP>>>$0 : Replace varnish to vinyl in VMOD source (Vinyl 9.0)"
    find . -type f -not -path './.git/*' -exec \
        sed -i 's/varnishtest/vtest/g;s/varnish/vinyl/g;s/VARNISH/VINYL/g;s/Varnish.Cache/Vinyl Cache/g;s/Varnish/Vinyl Cache/g;' {} +
else
    echo "VMP>>>$0 : No vcacheize available; keep Varnish VMOD source"
fi
