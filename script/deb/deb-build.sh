#!/bin/sh

echo "VMP>>>$0 : ${VMP_VMOD_NAME}"

${VMP_ROOT_DIR}/script/deb/deb-prefilter.sh
if [ -e ${VMP_ROOT_DIR}/vmod/src/${VMP_VMOD_NAME}_init.sh ]; then
    echo "VMP>>>${VMP_ROOT_DIR}/vmod/src/${VMP_VMOD_NAME}_init.sh : ${VMP_VMOD_NAME}"
    ${VMP_ROOT_DIR}/vmod/src/${VMP_VMOD_NAME}_init.sh
    if [ $? -ne 0 ]; then
        echo "Error"
        exit 1
    fi
fi
${VMP_ROOT_DIR}/script/deb/deb-postfilter.sh

