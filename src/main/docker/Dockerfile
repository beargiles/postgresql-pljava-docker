# syntax=docker/dockerfile:1

#
# Create image that adds the PostgreSQL extension development tools
# (pgxnclient and pgtap)
#
ARG PG_VERSION=15
FROM postgres:${PG_VERSION} AS pgxnclient

LABEL maintainer="Bear Giles <bgiles@coyotesong.com>"
LABEL org.opencontainers.image.authors="bgiles@coyotesong.com"
LABEL org.opencontainers.image.source="https://github.com/coyotesong/postgresql-pgxnclient-docker"
LABEL org.opencontainers.image.description="PostgreSQL with extension dev packages preinstalled (Debian)"

ARG PG_MAJOR=15

ENV DEBIAN_FRONTEND=noninteractive

EXPOSE 5432

VOLUME /var/log/postgresql/
VOLUME /docker-entrypoint-initdb.d/

# DO NOT do a general update - that would also update the postgresql version
# RUN /usr/bin/apt-get upgrade -y

# Update apt database then install pgtap, pgxnclient, plus a few packages
# useful for manual tasks later.
RUN /usr/bin/apt-get update && \
    /usr/bin/apt-get install -y \
       pgxnclient \
       postgresql-${PG_MAJOR}-pgtap \
       apt-utils \
       whiptail

ONBUILD RUN /usr/bin/apt-get update

# Remove cached files, unnecessary packages, etc.
RUN /usr/bin/apt-get autoclean && /usr/bin/apt-get autoremove

#
# Second image - it adds pl/java
#
FROM pgxnclient as pljava

LABEL maintainer="Bear Giles <bgiles@coyotesong.com>"
LABEL org.opencontainers.image.authors="bgiles@coyotesong.com"
LABEL org.opencontainers.image.description="PostgreSQL with pl/java preinstalled (Debian)"
LABEL org.opencontainers.image.source="https://github.com/beargiles/postgresql-pljava-docker"

ARG PG_MAJOR=15

ENV DEBIAN_FRONTEND=noninteractive

# Install pljava and a few useful java packages
RUN /usr/bin/apt-get install -y \
    postgresql-${PG_MAJOR}-pljava \
    libpostgresql-jdbc-java \
    libsaxon-java \
    libsaxonb-java

# Remove cached files, unnecessary packages, etc.
RUN /usr/bin/apt-get autoclean && apt-get autoremove

# Create 'pljava' extension on launch
COPY docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/
RUN /bin/cp /usr/share/postgresql/${PG_MAJOR}/pljava/pljava-examples-1.6.*.jar /tmp/pljava-examples-1.6.jar

RUN /bin/chmod 0755 /docker-entrypoint-initdb.d/0.1.pljava-vars.sh

#
# Third image - it creates and builds pljava extension (for local development)
#
FROM pljava as pljavadev

LABEL maintainer="Bear Giles <bgiles@coyotesong.com>"
LABEL org.opencontainers.image.authors="bgiles@coyotesong.com"
LABEL org.opencontainers.image.description="PostgreSQL with pl/java build environment preinstalled (Debian)"
LABEL org.opencontainers.image.source="https://github.com/beargiles/postgresql-pljava-docker"

ARG PG_MAJOR=15
ARG PLJAVA_VERSION=REL1_6_STABLE

# ARG JAVA_VERSION=11  # this isn't always visible...
ARG JAVA_VERSION=17    # from inspecting upstream docker image

ENV DEBIAN_FRONTEND=noninteractive

# install git, java, C compiler, and libraries
RUN /usr/bin/apt-get install -y \
      git \
      openjdk-${JAVA_VERSION}-jdk \
      maven \
      gcc \
      libecpg-dev \
      libkrb5-dev \
      postgresql-server-dev-${PG_MAJOR}

# clean up package repo
RUN /usr/bin/apt-get autoclean && /usr/bin/apt-get autoremove

# download source for both pl/java and corresponding deb package
# the latter allows us to build a new deb package with the local changes
WORKDIR /usr/local/src
RUN /usr/bin/git clone https://github.com/tada/pljava.git
RUN /usr/bin/apt-get source postgresql-${PG_MAJOR}-pljava

# change to source directory
WORKDIR /usr/local/src/pljava

# check out specific version
RUN git checkout ${PLJAVA_VERSION}

# build
RUN mvn install
