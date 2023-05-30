#!/usr/bin/bash

pgvers=12
pattern="${pgvers}."

# Strip surrounding quotes from string [$1: variable name]
function strip_quotes() {
    local -n var="$1"
    [[ "${var}" == \"*\" || "${var}" == \'*\' ]] && var="${var:1:-1}"
}

echo ${pattern}

ref="${1:-library/postgres:latest}"
repo="${ref%:*}"
tag="${ref##*:}"
token=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${repo}:pull" \
        | jq -r '.token')

tags=$(curl -H "Authorization: Bearer $token" \
     -s "https://registry-1.docker.io/v2/${repo}/tags/list" | \
        jq ".tags[] | select(. | startswith(\"${pattern}\")) | select(. | contains(\"-\") | not)")

echo $tags

for t in $tags
do
  strip_quotes t

  curl -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
                -H "Authorization: Bearer $token" \
                -s "https://registry-1.docker.io/v2/${repo}/manifests/$t" \
           | jq .

  digest=$(curl -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
                -H "Authorization: Bearer $token" \
                -s "https://registry-1.docker.io/v2/${repo}/manifests/$t" \
           | jq -r .config.digest)

  echo digest = $digest

  curl -H "Accept: application/vnd.docker.container.image.v1+json" \
        -H "Authorization: Bearer $token" \
        -s -L "https://registry-1.docker.io/v2/${repo}/blobs/${digest}" | jq .

#'.created | strptime("%Y-%m-%dT%H:%M:%S.%sZ") | mktime'

#       -s -L "https://registry-1.docker.io/v2/${repo}/blobs/${digest}" | jq '. | select((now - (.created | strptime("%Y-%m-%dT%H:%M:%S.%sZ")|mktime))/86400 < 360000) | join(.created, now, .created | strptime("%Y-%m-%dT%H:%M:%S.%sZ") | mktime)'

done

