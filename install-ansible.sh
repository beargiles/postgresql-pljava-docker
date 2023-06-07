#!/usr/bin/env bash

# copy package information for upstream ansible and docker
/usr/bin/cp build-resources/apt/sources.list.d/* /etc/apt/sources.list.d
/usr/bin/cp build-resources/keyrings/* /usr/share/keyrings

/usr/bin/apt-get update;

/usr/bin/apt-get install -y ansible ansible-core doocker-ce docker-compose-plugin

/usr/bin/ansible-galaxy collection install collection.docker
