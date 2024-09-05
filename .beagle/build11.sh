#!/usr/bin/env bash

set -ex

BUILD_VERSION="${BUILD_VERSION:-3.19}"
BUILD_OS="${BUILD_OS:-debian12}"
BUILD_ARCH="${BUILD_ARCH:-amd64}"

export DEBIAN_FRONTEND=noninteractive

apt update
apt install -y \
  gcc bsdmainutils build-essential git iptables \
  libnet1-dev libnl-route-3-dev libaio-dev libcap-dev libnl-3-dev libprotobuf-c-dev libprotobuf-dev libselinux1-dev \
  libbsd-dev libnftables-dev libdrm-dev libdrm-amdgpu1 libgnutls28-dev \
  pkg-config protobuf-c-compiler protobuf-compiler python3-minimal asciidoc

rm -rf build/system
make clean
make -j $(nproc) DESTDIR=build/system/ install

# 创建目录结构
mkdir -p build/system/DEBIAN

# 创建控制文件
cat <<EOF >build/system/DEBIAN/control
Package: criu
Version: ${BUILD_VERSION}
Section: utils
Priority: optional
Architecture: ${BUILD_ARCH}
Depends: libc6 (>= 2.28), libnet1-dev, libnl-3-dev, libprotobuf-c-dev, libselinux1-dev
Maintainer: Mengkzhaoyun <mengkzhaoyun@gmail.com>
Description: CRIU - Checkpoint/Restore in Userspace
EOF

# 打包成 .deb 文件
dpkg-deb --build build/system build/criu-${BUILD_VERSION}-${BUILD_OS}-${BUILD_ARCH}.deb
