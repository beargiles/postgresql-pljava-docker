#!/bin/sh

export REPO=beargiles

# ------------------------------------------------------------
#
# For simplicity this script is currently limited to the
# default version of official PostgreSQL images on hub.docker.com.
#
# That means PostgreSQL 12, 13, 14, and 15, all using pl/java 1.6.
#
# There are official images for PostgreSQL 11 but they are
# limited to 'alpine' Linux and Debian 'bullseye'
#
# There are no official images for PostgreSQL 10 and below.
#
# ------------------------------------------------------------

#
# Build docker images
#
for pg_version in 12.15 13.11 14.8 15.3
do
  pg_major=${pg_version%%.*}
  echo $pg_version $pg_major_version

  /usr/bin/docker build -f Dockerfile \
    --build-arg POSTGRES_VERSION=${pg_version} \
    --build-arg POSTGRES_MAJOR=${pg_major} \
    -t ${REPO}/pljava:${pg_version} .

  /usr/bin/docker tag $REPO/pljava:${pg_version} beargiles/pljava:${pg_major}

  if [ ${pg_major} = 15 ]; then
    /usr/bin/docker tag $REPO/pljava:${pg_major} beargiles/pljava:latest
  fi

  # now push the results...
done

