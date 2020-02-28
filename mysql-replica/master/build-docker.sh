#!/bin/bash

# Script builds and pushes app image to docker registery
set -e

if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <App Version> <Docker Image Tag Name> <Docker Username> <Dockerfile>"
  exit 1
fi

docker_tagged_image="$2:$1"

docker build . -f $4 -t $docker_tagged_image \
        --build-arg VCS_REF=$(git rev-parse --short HEAD) \
        --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
        --build-arg VERSION=0.1

docker login -u $3

docker tag $docker_tagged_image $3/$docker_tagged_image
docker push $3/$docker_tagged_image
