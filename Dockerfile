FROM alpine

MAINTAINER Jens Fischer

ENV HOME /root
ENV OSM2PGSQL_VERSION 0.96.0

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk update

RUN apk add --no-cache \
    postgresql-client \
    postgis@testing \
    gdal@testing \
    lua5.2 \
    expat \
    libbz2 \
    nodejs \
    nodejs-npm

# osm2psql
RUN apk add --no-cache \
	make \
	cmake \
	expat-dev \
	g++ \
	git \
	boost-dev \
	zlib-dev \
	bzip2-dev \
	proj4-dev@testing \
	geos-dev@testing \
	lua5.2-dev \
	postgresql-dev \
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
 && apk add --no-cache \
	make \
	cmake \
	expat-dev \
	g++ \
	wget \
	zlib-dev \
 && wget -O - http://m.m.i24.cc/osmconvert.c | cc -x c - -lz -O3 -o /usr/local/bin/osmconvert \
 && apk --purge del \
	make \
	cmake \
	expat-dev \
	g++ \
	git \
	boost-dev \
	zlib-dev \
	bzip2-dev \
	geos-dev \
	lua5.2-dev \
	postgresql-dev \
	expat-dev \
	wget \
	zlib-dev

WORKDIR ${HOME}

# carto
RUN npm install -g carto

ENTRYPOINT ["/bin/sh"]