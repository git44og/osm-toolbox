FROM alpine

MAINTAINER Jens Fischer <jf.seine.mail+mgserver@gmail.com>

ENV HOME /root
ENV OSM2PGSQL_VERSION 0.96.0

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk update

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
 && apk --purge del \
	make \
	cmake \
	expat-dev \
	g++ \
	git \
	boost-dev \
	zlib-dev \
	bzip2-dev \
	proj4-dev \
	geos-dev \
	lua5.2-dev \
	postgresql-dev

WORKDIR ${HOME}

# carto
RUN apk add --no-cache \
    nodejs \
    nodejs-npm \
 && npm install -g carto

RUN apk add --no-cache \
    bash
