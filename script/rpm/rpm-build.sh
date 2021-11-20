#!/bin/sh

echo "build ${VMP_VMOD_NAME}"


${VMP_ROOT_DIR}/script/rpm/rpm-prefilter.sh
if [ -e ${VMP_ROOT_DIR}/vmod/src/${VMP_VMOD_NAME}_init.sh ]; then
    ${VMP_ROOT_DIR}/vmod/src/${VMP_VMOD_NAME}_init.sh
fi
${VMP_ROOT_DIR}/script/rpm/rpm-postfilter.sh

