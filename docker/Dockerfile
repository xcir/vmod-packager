ARG VMP_DOCKER_BASE_IMG

FROM ${VMP_DOCKER_BASE_IMG}

ARG VARNISH_VER
ARG VARNISH_URL
ARG VARNISH_NOBUILD

RUN \
    rm -rf /tmp/varnish && \
    mkdir /tmp/varnish && \
    if [ ${VARNISH_NOBUILD} -eq 0 ]; then \
        cd /tmp/varnish && \
        mkdir src && \
        curl -sL ${VARNISH_URL} | tar zx -C src --strip-components 1 && \
        cd src && \
        ./autogen.sh && \
        ./configure --prefix=/usr && \
        make -sj32 && \
        make install; \
    fi

WORKDIR /tmp/varnish/
