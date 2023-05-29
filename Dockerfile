#
# All Dockerfile are identical except for the version for the base image and
# the Debian packages
#
ARG POSTGRES_VERSION
FROM postgres:${POSTGRES_VERSION}

ARG POSTGRES_MAJOR

LABEL maintainer="Bear Giles <bgiles@coyotesong.com>" \
      org.opencontainers.image.description="PL/Java language extension with PostgreSQL (on Debian)" \
      org.opencontainers.image.source="https://github.com/beargiles/postgresql-pljava-docker"

POSTGRES_MAJOR
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

# Install pljava, pgtap, and pgxnclient, plus a few packages
# useful for manual tasks later.
RUN DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get install -y \
    postgresql-${POSTGRES_MAJOR}-pljava \
    postgresql-${POSTGRES_MAJOR}-pgtap \
    pgxnclient \
    libsaxon-java libsaxonb-java libpostgresql-jdbc-java \
    apt-utils whiptail

# Remove cached files, unnecessary packages, etc.
RUN /usr/bin/apt-get autoclean && apt-get autoremove

# Create 'pljava' extension on launch
COPY docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/
RUN /bin/cp /usr/share/postgresql/${POSTGRES_MAJOR}/pljava/pljava-examples-1.6.*.jar /tmp/pljava-examples-1.6.jar

RUN /bin/chmod 0755 /docker-entrypoint-initdb.d/0.1.pljava-vars.sh
