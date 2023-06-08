# syntax=docker/dockerfile:1

#
# Create image that adds the PostgreSQL extension development tools
# (pgxnclient and pgtap)
#
ARG POSTGRES_VERSION
FROM postgres:${POSTGRES_VERSION} AS pgxnclient

LABEL maintainer="Bear Giles <bgiles@coyotesong.com>"
LABEL org.opencontainers.image.authors="bgiles@coyotesong.com"
LABEL org.opencontainers.image.source="https://github.com/beargiles/postgresql-pljava-docker"
LABEL org.opencontainers.image.description="PostgreSQL with extension dev packages preinstalled (Debian)"

ARG POSTGRES_MAJOR

EXPOSE 5432

VOLUME /var/log/postgresql/
VOLUME /docker-entrypoint-initdb.d/

# Update apt and current packages. I used two lines, instead
# of the recommended single line, in order to make it clear
# that I was setting the DEBIAN_FRONTEND value on the upgrade.
# (Due to updating postgresql-common)
#
RUN /usr/bin/apt-get update
RUN DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get upgrade -y

# Install pgtap, pgxnclient, plus a few packages
# useful for manual tasks later.
RUN DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get install -y \
    pgxnclient postgresql-${POSTGRES_MAJOR}-pgtap \
    apt-utils whiptail

#
# Second image - it adds pl/java
#
FROM pgxnclient

LABEL maintainer="Bear Giles <bgiles@coyotesong.com>"
LABEL org.opencontainers.image.authors="bgiles@coyotesong.com"
LABEL org.opencontainers.image.description="PostgreSQL with pl/java preinstalled (Debian)"
LABEL org.opencontainers.image.source="https://github.com/beargiles/postgresql-pljava-docker"

ARG POSTGRES_MAJOR

# Install pljava and a few useful java packages
RUN DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get install -y \
    postgresql-${POSTGRES_MAJOR}-pljava \
    libpostgresql-jdbc-java \
    libsaxon-java libsaxonb-java

# Remove cached files, unnecessary packages, etc.
RUN /usr/bin/apt-get autoclean && apt-get autoremove

# Create 'pljava' extension on launch
COPY docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/
RUN /bin/cp /usr/share/postgresql/${POSTGRES_MAJOR}/pljava/pljava-examples-1.6.*.jar /tmp/pljava-examples-1.6.jar

RUN /bin/chmod 0755 /docker-entrypoint-initdb.d/0.1.pljava-vars.sh
