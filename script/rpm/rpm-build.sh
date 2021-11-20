#!/bin/sh

echo "build ${VMP_VMOD_NAME}"


${VMP_VARNISH_DIR}/script/rpm/rpm-prefilter.sh
if [ -e ${VMP_VARNISH_DIR}/vmod/src/${VMP_VMOD_NAME}_init.sh ]; then
    ${VMP_VARNISH_DIR}/vmod/src/${VMP_VMOD_NAME}_init.sh
fi
${VMP_VARNISH_DIR}/script/rpm/rpm-postfilter.sh

