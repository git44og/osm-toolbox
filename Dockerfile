FROM ubuntu

LABEL Jens Fischer

ENV HOME /root
ENV OSM2PGSQL_VERSION 0.96.0
ENV OSMCONVERT_VERSION 0.9

RUN apt-get update \
 && DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt-get install -y \
    postgresql-client \
    postgresql \
    postgis \
    gdal-bin \
    proj-bin \
    lua5.2 \
    expat \
    libbz2-dev \
    nodejs \
    npm \
    git \
    libboost-all-dev \
    bzip2 \
    cmake \
    make \
    expat \
    libgeos-dev \
    g++ \
    zlib1g-dev
RUN apt-get install -y osm2pgsql
RUN apt-get install -y osmctools

WORKDIR ${HOME}

# carto
RUN npm install -g carto

ENTRYPOINT ["/bin/sh"]