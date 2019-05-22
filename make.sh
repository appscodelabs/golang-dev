#!/bin/bash
set -xeuo pipefail

docker build --pull -t appscode/golang-dev:1.12.5-alpine -f Dockerfile.alpine .
docker push appscode/golang-dev:1.12.5-alpine

docker build --pull -t appscode/golang-dev:1.12.5-stretch -f Dockerfile.stretch .
docker push appscode/golang-dev:1.12.5-stretch
