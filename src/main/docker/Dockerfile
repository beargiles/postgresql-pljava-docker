#
# Create image that adds the PostgreSQL extension development tools
# (pgxnclient and pgtap)
#
ARG PG_VERSION=16.0
ARG DEBIAN_RELEASE=bookworm
FROM postgres:${PG_VERSION}-${DEBIAN_RELEASE} AS pgxnclient

LABEL maintainer="Bear Giles <bgiles@coyotesong.com>"
LABEL org.opencontainers.image.authors="bgiles@coyotesong.com"
LABEL org.opencontainers.image.source="https://github.com/coyotesong/postgresql-pgxnclient-docker"
LABEL org.opencontainers.image.description="PostgreSQL with extension dev packages preinstalled (Debian)"

ARG PG_MAJOR=16

ENV DEBIAN_FRONTEND=noninteractive

EXPOSE 5432

VOLUME /var/log/postgresql/
VOLUME /docker-entrypoint-initdb.d/

# add apt source repository (note: error with /usr/bin/sed)
RUN sed -e 's/^deb /deb-src /' </etc/apt/sources.list.d/pgdg.list >/etc/apt/sources.list.d/pgdg-src.list

# DO NOT do a general update - that would also update the postgresql version
# Unfortunately that also means we can't pull debian pljava source later
# RUN /usr/bin/apt-get upgrade -y

# Update apt database then install pgtap, pgxnclient, plus a few packages
# useful for manual tasks later.
RUN /usr/bin/apt-get update && /usr/bin/apt-get install -y \
       pgxnclient \
       postgresql-${PG_MAJOR}-pgtap \
       apt-utils \
       whiptail

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

ARG PG_MAJOR=16

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

ARG PLJAVA_VERSION=1.6.6
ARG PG_MAJOR=16

# ARG JAVA_VERSION=11
ARG JAVA_VERSION=17    # from inspecting upstream docker image

ENV DEBIAN_FRONTEND=noninteractive

# install git, java, C compiler, and libraries
RUN /usr/bin/apt-get update && \
    /usr/bin/apt-get install -y \
      debhelper-compat \
      default-jdk-headless \
      dpkg-dev \
      gcc \
      git \
      libecpg-dev \
      libkrb5-dev \
      maven \
      openjdk-${JAVA_VERSION}-jdk \
      postgresql-all \
      postgresql-server-dev-${PG_MAJOR}

# download source for pl/java
# the latter allows us to build a new deb package with the local changes
WORKDIR /usr/local/src

RUN /usr/bin/apt-get source postgresql-${PG_MAJOR}-pljava

WORKDIR /usr/local/src/postgresql-pljava-${PLJAVA_VERSION}

RUN /usr/bin/dpkg-buildpackage --build=binary --no-sign

