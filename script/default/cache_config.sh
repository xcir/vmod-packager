#!/bin/sh
# Shared target information, sourced by the host and container build scripts.
case "${VMP_SOFT_DIST_NAME}" in
    varnish)
        VMP_CACHE_PKG_NAME=varnish
        VMP_PKG_CONFIG_NAME=varnishapi
        ;;
    vinyl)
        VMP_CACHE_PKG_NAME=vinyl-cache
        VMP_PKG_CONFIG_NAME=vinylapi
        ;;
    *)
        echo "Error: Unknown cache flavor: ${VMP_SOFT_DIST_NAME}" >&2
        return 1
        ;;
esac
export VMP_CACHE_PKG_NAME VMP_PKG_CONFIG_NAME

vmp_configure_vmod() {
    if ! VMP_VMOD_DIR=$(pkg-config --variable=vmoddir "${VMP_PKG_CONFIG_NAME}"); then
        echo "Error: Could not read vmoddir from ${VMP_PKG_CONFIG_NAME}" >&2
        return 1
    fi
    case "${VMP_VMOD_DIR}" in
        /*) ;;
        *)
            echo "Error: Invalid vmoddir from ${VMP_PKG_CONFIG_NAME}: ${VMP_VMOD_DIR}" >&2
            return 1
            ;;
    esac
    VMP_VMOD_PKG_NAME="${VMP_VMOD_PFX}${VMP_VMOD_NAME}-${VMP_SOFT_DIST_NAME}"
    export VMP_VMOD_DIR VMP_VMOD_PKG_NAME
}
