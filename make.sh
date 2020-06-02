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


TAG=1.14.4

semverParseInto $TAG MAJOR MINOR PATCH SPECIAL
Mm=${MAJOR}.${MINOR}

docker build --pull -t appscode/golang-dev:$TAG -f Dockerfile .
docker push appscode/golang-dev:$TAG

docker tag appscode/golang-dev:$TAG appscode/golang-dev:$Mm
docker push appscode/golang-dev:$Mm
