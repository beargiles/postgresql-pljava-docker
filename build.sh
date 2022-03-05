#!/bin/sh

#
# Build docker images
#
/usr/bin/docker build -f Dockerfile    -t beargiles/pljava:14.2 .
/usr/bin/docker build -f Dockerfile.13 -t beargiles/pljava:13.6 .
/usr/bin/docker build -f Dockerfile.12 -t beargiles/pljava:12.10 .
/usr/bin/docker build -f Dockerfile.11 -t beargiles/pljava:11.15 .
/usr/bin/docker build -f Dockerfile.10 -t beargiles/pljava:10.20 .

#
# Add tags
#
/usr/bin/docker tag beargiles/pljava:14.2 beargiles/pljava:latest
/usr/bin/docker tag beargiles/pljava:14.2 beargiles/pljava:14
/usr/bin/docker tag beargiles/pljava:13.6 beargiles/pljava:13
/usr/bin/docker tag beargiles/pljava:12.10 beargiles/pljava:12
/usr/bin/docker tag beargiles/pljava:11.15 beargiles/pljava:11
/usr/bin/docker tag beargiles/pljava:10.20 beargiles/pljava:10


