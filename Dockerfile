FROM golang:1.17.5

LABEL org.opencontainers.image.source https://github.com/appscodelabs/golang-dev

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-utils         \
    bash              \
    build-essential   \
    bzip2             \
    bzr               \
    ca-certificates   \
    git               \
    gnupg             \
    mercurial         \
    protobuf-compiler \
    socat             \
    upx               \
    wget              \
    xz-utils          \
    zip               \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /tmp/*

# install protobuf
RUN mkdir -p /go/src/github.com/golang \
  && cd /go/src/github.com/golang \
  && rm -rf protobuf \
  && git clone https://github.com/golang/protobuf.git \
  && cd protobuf \
  && git checkout v1.3.1 \
  && GO111MODULE=on go install ./... \
  && cd /go \
  && rm -rf /go/pkg /go/src

RUN set -x                                        \
  && export GOBIN=/usr/local/bin                  \
  && go install github.com/bwplotka/bingo@latest \
  && bingo get -l github.com/bwplotka/bingo \
  && bingo get -l golang.org/x/tools/cmd/goimports \
  && bingo get -l github.com/onsi/ginkgo/ginkgo@v1.15.0 \
  && bingo get -l github.com/golangci/golangci-lint/cmd/golangci-lint@v1.31.0 \
  && bingo get -l github.com/appscodelabs/gh-tools@v0.2.10 \
  && bingo get -l github.com/appscodelabs/hugo-tools@v0.2.20 \
  && bingo get -l github.com/appscodelabs/ltag@v0.2.0 \
  && bingo get -l github.com/vbatts/git-validation@master \
  && bingo get -l mvdan.cc/sh/v3/cmd/shfmt@v3.3.0 \
  && bingo get -l kubepack.dev/chart-doc-gen@v0.4.2 \
  && bingo get -l github.com/go-bindata/go-bindata/go-bindata@ee3c2418e3682cc4a4e6c5dd1b32d0b98f7e2c55 \
  && export GOBIN=                                \
  && cd /go \
  && rm -rf /go/pkg /go/src

COPY reimport.py /usr/local/bin/reimport.py
COPY reimport3.py /usr/local/bin/reimport3.py

RUN set -x                                        \
  && wget https://dl.k8s.io/$(curl -fsSL https://storage.googleapis.com/kubernetes-release/release/stable.txt)/kubernetes-client-linux-amd64.tar.gz \
  && tar -xzvf kubernetes-client-linux-amd64.tar.gz \
  && mv kubernetes/client/bin/kubectl /usr/bin/kubectl \
  && chmod +x /usr/bin/kubectl \
  && rm -rf kubernetes kubernetes-client-linux-amd64.tar.gz

RUN set -x \
  && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
