#!/bin/sh

echo "VMP>>>$0 : ${VMP_VMOD_NAME}"

${VMP_ROOT_DIR}/script/deb/deb-prefilter.sh
if [ -e ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_init.sh ]; then
    echo "VMP>>>${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_init.sh : ${VMP_VMOD_NAME}"
    ${VMP_VMOD_ORG_SRC_DIR}/${VMP_VMOD_NAME}_init.sh
    if [ $? -ne 0 ]; then
        echo "Error" 1>&2
        exit 1
    fi
fi
${VMP_ROOT_DIR}/script/deb/deb-postfilter.sh

