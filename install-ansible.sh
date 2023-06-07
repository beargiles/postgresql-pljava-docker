#!/usr/bin/env bash

# copy package information for upstream ansible and docker
/usr/bin/cp build-resources/apt/sources.list.d/* /etc/apt/sources.list.d
/usr/bin/cp build-resources/keyrings/* /usr/share/keyrings

/usr/bin/apt-get update;

/usr/bin/apt-get install -y ansible ansible-core docker-ce docker-compose-plugin

# see link for how to add signature verification
# https://docs.ansible.com/ansible/latest/collections_guide/collections_installing.html#install-multiple-collections-with-a-requirements-file

/usr/bin/ansible-galaxy install -r requirements.txt
