#!/bin/sh

# this should be determined at runtime!

PG_VERSION_16=16rc1   # postgresql-16-pljava does not yet exist

PG_VERSION_15=15.4
PG_VERSION_14=14.9
# PG_VERSION_13=13.12

# PLJAVA_VERSION=1.6.4

#
# Build everything
#
for release in bookworm bullseye
do
  for tag in pgxnclient pljava
  do
    # docker build --build-arg PG_VERSION=${PG_VERSION_16} --build-arg PG_MAJOR=16 --build-arg RELEASE=${release} --target ${tag} --tag beargiles/postgres-${tag}:${PG_VERSION_16}-${release} .
    docker build --build-arg PG_VERSION=${PG_VERSION_15} --build-arg PG_MAJOR=15 --build-arg RELEASE=${release} --target ${tag} --tag beargiles/postgres-${tag}:${PG_VERSION_15}-${release} .
    docker build --build-arg PG_VERSION=${PG_VERSION_14} --build-arg PG_MAJOR=14 --build-arg RELEASE=${release} --target ${tag} --tag beargiles/postgres-${tag}:${PG_VERSION_14}-${release} .
  done

  # docker build --build-arg PG_VERSION=${PG_VERSION_16} --build-arg PG_MAJOR=16 --build-arg RELEASE=${release} --target pljavadev --tag beargiles/postgres-pljava-dev:${PG_VERSION_16}-${release} .
  docker build --build-arg PG_VERSION=${PG_VERSION_15} --build-arg PG_MAJOR=15 --build-arg RELEASE=${release} --target pljavadev --tag beargiles/postgres-pljava-dev:${PG_VERSION_15}-${release} .
  docker build --build-arg PG_VERSION=${PG_VERSION_14} --build-arg PG_MAJOR=14 --build-arg RELEASE=${release} --target pljavadev --tag beargiles/postgres-pljava-dev:${PG_VERSION_14}-${release} .
done

#
# Update the top tags for each release
#
for release in bookworm bullseye
do
  for tag in pgxnclient pljava pljava-dev
  do
    # docker tag beargiles/postgres-${tag}:${PG_VERSION_16}-${release} beargiles/postgres-${tag}:16rc1-${release}
    docker tag beargiles/postgres-${tag}:${PG_VERSION_15}-${release} beargiles/postgres-${tag}:15-${release}
    docker tag beargiles/postgres-${tag}:${PG_VERSION_14}-${release} beargiles/postgres-${tag}:14-${release}
  done
done

for tag in pgxnclient pljava pljava-dev
do
  # docker tag beargiles/postgres-${tag}:${PG_VERSION_16}-${release} beargiles/postgres-${tag}:16rc1
  docker tag beargiles/postgres-${tag}:${PG_VERSION_15}-bookworm beargiles/postgres-${tag}:15
  docker tag beargiles/postgres-${tag}:${PG_VERSION_14}-bookworm beargiles/postgres-${tag}:14
done

#
# Finally update the 'latest' version.
#
for tag in pgxnclient pljava pljava-dev
do
  docker tag beargiles/postgres-${tag}:${PG_VERSION_15}-${release} beargiles/postgres-${tag}:latest
done
