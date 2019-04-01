FROM alpine

MAINTAINER Jens Fischer

ENV HOME /root
ENV OSM2PGSQL_VERSION 0.96.0
ENV OSMCONVERT_VERSION 0.9

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk update

RUN apk add --no-cache \
    postgresql-client \
    postgis@testing \
    gdal@testing \
    proj4-dev@testing \
    lua5.2 \
    expat \
    libbz2 \
    nodejs \
    nodejs-npm

RUN apk add --no-cache \
    boost-dev \
    bzip2-dev \
    cmake \
    expat-dev \
    geos-dev@testing \
    git \
    g++ \
    lua5.2-dev \
    make \
    postgresql-dev \
    zlib-dev \
# build osm2pgsql
 && mkdir -p ${HOME}/src \
 && cd ${HOME}/src \
 && git clone --depth 1 --branch ${OSM2PGSQL_VERSION} https://github.com/openstreetmap/osm2pgsql.git \
 && mkdir -p osm2pgsql/build \
 && cd osm2pgsql/build \
 && cmake -DLUA_LIBRARY=/usr/lib/liblua-5.2.so.0 .. \
 && make \
 && make install \
 && cd $HOME \
 && rm -rf src \
# build osmconvert
 && mkdir -p ${HOME}/src \
 && git clone --depth 1 --branch ${OSMCONVERT_VERSION} https://gitlab.com/osm-c-tools/osmctools.git ${HOME}/src \
 && cc ${HOME}/src/src/osmconvert.c -lz -o osmconvert \
 && mv osmconvert /usr/local/bin \
 && rm -rf src \
 && apk --purge del \
    boost-dev \
    bzip2-dev \
    cmake \
    expat-dev \
    g++ \
    geos-dev \
    git \
    lua5.2-dev \
    make \
    postgresql-dev \
    zlib-dev

WORKDIR ${HOME}

# carto
RUN npm install -g carto

ENTRYPOINT ["/bin/sh"]