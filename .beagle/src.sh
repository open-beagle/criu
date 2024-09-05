#!/usr/bin/env bash

set -ex

apt update

apt install -y curl

mkdir -p ./build/src
if ! [[ -e $BUILD_ROOT/build/criu-${BUILD_VERSION}.tar.gz  ]]; then
  curl -x socks5://www.ali.wodcloud.com:1283 \
    -L http://github.com/checkpoint-restore/criu/archive/v${BUILD_VERSION}/criu-${BUILD_VERSION}.tar.gz > \
    ./build/criu-${BUILD_VERSION}.tar.gz 
fi

rm -rf $BUILD_ROOT/build/src/criu-${BUILD_VERSION}
tar -xzvf $BUILD_ROOT/build/criu-${BUILD_VERSION}.tar.gz  -C $BUILD_ROOT/build/src
