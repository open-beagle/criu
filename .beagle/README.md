# criu

<https://github.com/checkpoint-restore/criu>

```bash
git remote add upstream git@github.com:checkpoint-restore/criu.git

git fetch upstream

git merge v3.9
```

## build

```bash
# golang build
docker run -it --rm \
-v $PWD/:/go/src/github.com/checkpoint-restore/criu \
-w /go/src/github.com/checkpoint-restore/criu \
-e VERSION=v3.9-beagle \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.22 \
bash .beagle/build.sh

sudo apt update && sudo apt-get install -y \
    protobuf-c-compiler protobuf-compiler libprotobuf-dev libprotobuf-c-dev \
    libnl-3-dev libnet-dev libcap-dev libaio-dev python3-protobuf \
    libnftnl-dev iproute2 pkg-config build-essential libbsd-dev \
    asciidoc xmlto libtool automake

make

make DESTDIR=.tmp/ install
```

## test

```bash
file _output/linux-amd64/criu

# amd64-test
docker run -it --rm \
-v $PWD/:/go/src/github.com/checkpoint-restore/criu \
-w /go/src/github.com/checkpoint-restore/criu \
registry.cn-qingdao.aliyuncs.com/wod/debian:bullseye-amd64 \
./_output/linux-amd64/criu -v

docker run -it --rm \
-v $PWD/:/go/src/github.com/checkpoint-restore/criu \
-w /go/src/github.com/checkpoint-restore/criu \
registry.cn-qingdao.aliyuncs.com/wod/alpine:3-amd64 \
./_output/linux-amd64/criu -v

# arm64-test
docker run -it --rm \
-v $PWD/:/go/src/github.com/checkpoint-restore/criu \
-w /go/src/github.com/checkpoint-restore/criu \
registry.cn-qingdao.aliyuncs.com/wod/debian:bullseye-arm64 \
./_output/linux-arm64/criu -v

docker run -it --rm \
-v $PWD/:/go/src/github.com/checkpoint-restore/criu \
-w /go/src/github.com/checkpoint-restore/criu \
registry.cn-qingdao.aliyuncs.com/wod/alpine:3-arm64 \
./_output/linux-arm64/criu -v

# loong64-test
docker run -it --rm \
-v $PWD/:/go/src/github.com/checkpoint-restore/criu \
-w /go/src/github.com/checkpoint-restore/criu \
registry.cn-qingdao.aliyuncs.com/wod/alpine:3-loong64 \
./_output/linux-loong64/criu -v
```

## cache

```bash
# 构建缓存-->推送缓存至服务器
docker run --rm \
  -e PLUGIN_REBUILD=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="criu" \
  -e PLUGIN_MOUNT="./.git" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0

# 读取缓存-->将缓存从服务器拉取到本地
docker run --rm \
  -e PLUGIN_RESTORE=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="criu" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0
```
