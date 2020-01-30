#!/bin/bash
set -xeuo pipefail

docker build --pull -t appscode/golang-dev:1.13.7 -f Dockerfile .
docker push appscode/golang-dev:1.13.7
