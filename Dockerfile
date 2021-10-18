FROM python:3.9-alpine3.13

ENV HOME /root

# osm2pgsql
RUN apk update \
 && apk --no-cache add \
        cmake=3.18.4-r1 \
        make=4.3-r0 \
        g++=10.2.1_pre1-r3 \
        boost-dev=1.72.0-r6 \
        expat-dev=2.2.10-r1 \
        bzip2-dev=1.0.8-r1 \
        zlib-dev=1.2.11-r3 \
        libpq=13.4-r0 \
        proj-dev=7.1.1-r0 \
        lua5.3-dev=5.3.6-r0 \
        postgresql-dev=13.4-r0 \
        git=2.30.2-r0 \
 && cd ${HOME} \
 && mkdir src \
 && cd src \
 && git clone git://github.com/openstreetmap/osm2pgsql.git \
 && cd osm2pgsql \
 # in order to switch to version 1.5.1
 # && git checkout c2b54e2125984ea2efd0ea803f59b907badebcd7 \
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
RUN apk update \
 && apk --no-cache add \
	    cmake=3.18.4-r1 \
	    make=4.3-r0 \
	    expat-dev=2.2.10-r1 \
	    g++=10.2.1_pre1-r3 \
	    wget=1.21.1-r1 \
	    zlib-dev=1.2.11-r3 \
 && wget -O - http://m.m.i24.cc/osmconvert.c | cc -x c - -lz -O3 -o /usr/local/bin/osmconvert \
 && apk --purge del \
	    make \
	    cmake \
	    expat-dev \
	    g++ \
	    wget \
	    zlib-dev

# allow for pip install
RUN apk update \
 && apk --no-cache add \
        gcc=10.2.1_pre1-r3 \
        gfortran=10.2.1_pre1-r3 \
        py-pip=20.3.4-r0 \
        build-base=0.5-r2 \
        wget=1.21.1-r1 \
        freetype-dev=2.10.4-r1 \
        libpng-dev=1.6.37-r1 \
        openblas-dev=0.3.13-r0 \
 && ln -s /usr/include/locale.h /usr/include/xlocale.h

# install gdal and other packages and prepare for pip install gdal
RUN apk add --no-cache \
        postgresql-client=13.4-r0 \
        postgis=3.1.1-r0 \
        lua5.3=5.3.6-r0 \
        expat=2.2.10-r1 \
        libbz2=1.0.8-r1 \
        npm=14.18.1-r0 \
        geos=3.8.1-r2 \
        #  version of gdal-dev needs to be the same as gdal in pip install
        gdal=3.1.4-r3 \
        gdal-dev=3.1.4-r3 \
        gdal-tools=3.1.4-r3
RUN pip install 'numpy==1.21.2' \
# numpy needs to be installed prior to gdal
 && pip install 'gdal==3.1.4'

# install carto
RUN npm install -g carto

WORKDIR ${HOME}

ENTRYPOINT ["/bin/sh"]