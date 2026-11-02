ARG VMP_DOCKER_BASE_IMG=vmod-packager/base:resolute

FROM ${VMP_DOCKER_BASE_IMG}

ARG VARNISH_VER
ARG VARNISH_URL
ARG VARNISH_NOBUILD

COPY script/default/varnish_config.sh /tmp/varnish_config.sh

RUN \
    rm -rf /tmp/varnish && \
    mkdir /tmp/varnish && \
    if [ ${VARNISH_NOBUILD} -eq 0 ]; then \
        cd /tmp/varnish && \
        mkdir src && \
        curl --fail --show-error --location --connect-timeout 15 --retry 2 --retry-all-errors --output source.tgz "${VARNISH_URL}" && \
        tar zxf source.tgz -C src --strip-components 1 && \
        rm source.tgz && \
        cd src && \
        ./autogen.sh && \
        sh /tmp/varnish_config.sh && \
        make -sj32 && \
        make install; \
    fi

WORKDIR /tmp/varnish/
