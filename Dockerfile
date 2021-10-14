FROM debian:11.1

LABEL Jens Fischer

ENV HOME /root
ENV OSM2PGSQL_VERSION 0.96.0
ENV OSMCONVERT_VERSION 0.9

RUN apt-get update \
#  && DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
 && apt-get install -y \
    postgresql-client \
    postgresql \
    postgis \
    gdal-bin \
    proj-bin \
    lua5.3 \
    expat \
    nodejs \
    npm \
 && apt-get clean
    # expat \
    # git \
    # libgeos-dev \
    # libbz2-dev \
    # bzip2 \
    # g++ \
    # libboost-all-dev \
    # zlib1g-dev
RUN apt-get install -y \
    osm2pgsql \
    osmctools

WORKDIR ${HOME}

# carto
RUN npm install -g carto

ENTRYPOINT ["/bin/sh"]