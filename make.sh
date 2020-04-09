#!/bin/bash
set -xeuo pipefail

docker build --pull -t appscode/golang-dev:1.14.2 -f Dockerfile .
docker push appscode/golang-dev:1.14.2
