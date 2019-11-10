FROM golang:1.12.13-buster

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates wget git bash mercurial bzr xz-utils socat build-essential protobuf-compiler

RUN set -x \
  && wget https://github.com/upx/upx/releases/download/v3.95/upx-3.95-amd64_linux.tar.xz \
  && tar -xf upx-3.95-amd64_linux.tar.xz \
  && mv upx-3.95-amd64_linux/upx /usr/local/bin \
  && rm -rf upx-3.95-amd64_linux upx-3.95-amd64_linux.tar.xz

RUN set -x                                        \
  && export GO111MODULE=on                        \
  && export GOBIN=/usr/local/bin                  \
  && go get -u golang.org/x/tools/cmd/goimports   \
  && go get -u github.com/onsi/ginkgo/ginkgo@v1.10.1 \
  && go get github.com/golangci/golangci-lint/cmd/golangci-lint@v1.21.0 \
  && go get github.com/appscodelabs/gh-tools@v0.1.0 \
  && go get github.com/appscodelabs/hugo-tools@v0.2.4 \
  && go get github.com/appscodelabs/ltag@v0.1.1 \
  && go get github.com/vbatts/git-validation@master \
  && go get -u github.com/mvdan/sh/cmd/shfmt \
  && go get github.com/go-bindata/go-bindata/go-bindata@ee3c2418e3682cc4a4e6c5dd1b32d0b98f7e2c55 \
  && export GOBIN=                                \
  && export GO111MODULE=auto                      \
  && rm -rf go.mod go.sum /go/pkg/mod

COPY reimport.py /usr/local/bin/reimport.py
COPY reimport3.py /usr/local/bin/reimport3.py

# install protobuf
RUN mkdir -p /go/src/github.com/golang \
  && cd /go/src/github.com/golang \
  && rm -rf protobuf \
  && git clone https://github.com/golang/protobuf.git \
  && mkdir -p /go/src/google.golang.org/genproto \
  && cd /go/src/google.golang.org \
  && git clone https://github.com/googleapis/go-genproto.git genproto \
  && cd /go/src/google.golang.org/genproto \
  && git checkout b515fa19cec88c32f305a962f34ae60068947aea \
  && cd /go/src/github.com/golang/protobuf \
  && git checkout v1.2.0 \
  && go install ./...
