#!/usr/bin/env bash

set -ex

BUILD_VERSION="${BUILD_VERSION:-3.19}"
BUILD_OS="${BUILD_OS:-debian12}"
BUILD_ARCH="${BUILD_ARCH:-amd64}"

BUILD_ROOT=${PWD}

source $BUILD_ROOT/.beagle/src.sh

export DEBIAN_FRONTEND=noninteractive

apt update
apt install -y --no-install-recommends \
  build-essential git pkg-config \
  libprotobuf-dev libprotobuf-c-dev protobuf-c-compiler protobuf-compiler python3-protobuf \
  libbsd-dev iproute2 libnftables-dev libcap-dev libnet1-dev libaio-dev libdrm-dev libgnutls28-dev libnl-3-dev \
  python3-future python3-pip asciidoc xmlto

rm -rf $BUILD_ROOT/build/system

cd $BUILD_ROOT/build/src/criu-${BUILD_VERSION}
make clean
make -j $(nproc) DESTDIR=$BUILD_ROOT/build/system/ install

# 创建目录结构
mkdir -p $BUILD_ROOT/build/system/DEBIAN

# 创建控制文件
cat <<EOF >$BUILD_ROOT/build/system/DEBIAN/control
Package: criu
Version: ${BUILD_VERSION}
Section: utils
Priority: optional
Architecture: ${BUILD_ARCH}
Depends: libc6 (>= 2.28), libprotobuf-c-dev, libbsd-dev, iproute2, libcap-dev, libnet1-dev, libaio-dev, libdrm-dev, libnl-3-dev
Maintainer: Mengkzhaoyun <mengkzhaoyun@gmail.com>
Description: CRIU - Checkpoint/Restore in Userspace
EOF

# 打包成 .deb 文件
dpkg-deb --build $BUILD_ROOT/build/system $BUILD_ROOT/build/criu-${BUILD_VERSION}-${BUILD_OS}-${BUILD_ARCH}.deb
