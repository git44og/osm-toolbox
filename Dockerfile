FROM alpine:3.12

LABEL Jens Fischer

ENV HOME /root

# osm2pgsql
RUN apk update \
 && apk --no-cache add \
        cmake \
        make \
        g++ \
        boost-dev \
        expat-dev \
        bzip2-dev \
        zlib-dev \
        libpq \
        proj-dev \
        lua5.3-dev \
        postgresql-dev \
        git \
 && cd ${HOME} \
 && mkdir src \
 && cd src \
 && git clone git://github.com/openstreetmap/osm2pgsql.git \
 && cd osm2pgsql \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make \
 && make install \
 && cd ${HOME} \
 && rm -rf src \
 && apk --purge del \
        cmake \
        make \
        g++ \
        boost-dev \
        expat-dev \
        bzip2-dev \
        zlib-dev \
        libpq \
        proj-dev \
        lua5.3-dev \
        postgresql-dev \
        git
# osmconvert
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
	    wget \
	    zlib-dev
RUN apk update \
 && apk --no-cache add \
        postgresql-client \
        postgis \
        gdal \
        lua5.3 \
        expat \
        libbz2 \
        npm
WORKDIR ${HOME}
# carto
RUN npm install -g carto

ENTRYPOINT ["/bin/sh"]