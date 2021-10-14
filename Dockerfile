FROM python:3.6-alpine3.9

LABEL Jens Fischer

ENV HOME /root
ENV OSM2PGSQL_VERSION 0.96.0

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk update

RUN apk add --no-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    postgresql-client \
    postgis \
    gdal \
    lua5.2 \
    expat \
    libbz2 \
    npm

# osm2psql
RUN apk add --no-cache --virtual .osm2pgsql-build-deps \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
	make \
	cmake \
	expat-dev \
	g++ \
	git \
	boost-dev \
	zlib-dev \
	bzip2-dev \
	proj-dev \
	geos-dev \
	lua5.3-dev \
    libpq \
	postgresql-dev
# build osm2pgsql
RUN mkdir /home/root \
    && wget -O /home/root/osm2pgsql.tar.gz "https://github.com/openstreetmap/osm2pgsql/archive/master.tar.gz" \
    && tar \
        --extract \
        --file /home/root/osm2pgsql.tar.gz \
        --directory /home/root \
    && rm /home/root/osm2pgsql.tar.gz \
    && cd /home/root/osm2pgsql-master \
    && mkdir build && cd build \
    # && make && make man && make install \
    && cmake ..
    # && cmake -DLUA_LIBRARY=/usr/lib/lua5.2/liblua.so ..
    # && cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTS=ON
# RUN mkdir -p ${HOME}/src \
#  && cd ${HOME}/src \
#  && git clone --depth 1 --branch ${OSM2PGSQL_VERSION} https://github.com/openstreetmap/osm2pgsql.git \
#  && mkdir -p osm2pgsql/build \
#  && cd osm2pgsql/build \
#  && cmake -DLUA_LIBRARY=/usr/lib/liblua-5.2.so.0 .. \
#  && make \
#  && make install \
#  && cd $HOME \
#  && rm -rf src \
# build osmconvert
RUN apk add --no-cache \
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