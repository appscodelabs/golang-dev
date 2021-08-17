#!/bin/bash
set -xeuo pipefail

# ref: https://github.com/cloudflare/semver_bash
function semverParseInto() {
    local RE='[^0-9]*\([0-9]*\)[.]\([0-9]*\)[.]\([0-9]*\)\([0-9A-Za-z-]*\)'
    #MAJOR
    eval $2=`echo $1 | sed -e "s#$RE#\1#"`
    #MINOR
    eval $3=`echo $1 | sed -e "s#$RE#\2#"`
    #MINOR
    eval $4=`echo $1 | sed -e "s#$RE#\3#"`
    #SPECIAL
    eval $5=`echo $1 | sed -e "s#$RE#\4#"`
}


TAG=1.17.0
REGISTRY=${REGISTRY:-appscode}

semverParseInto $TAG MAJOR MINOR PATCH SPECIAL
Mm=${MAJOR}.${MINOR}

docker build --pull -t $REGISTRY/golang-dev:$TAG -f Dockerfile .
docker push $REGISTRY/golang-dev:$TAG

docker tag $REGISTRY/golang-dev:$TAG $REGISTRY/golang-dev:$Mm
docker push $REGISTRY/golang-dev:$Mm
