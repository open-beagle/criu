# criu

<https://github.com/checkpoint-restore/criu>

```bash
git remote add upstream git@github.com:checkpoint-restore/criu.git

git fetch upstream

git merge v3.19
```

## build

```bash
docker pull registry.cn-qingdao.aliyuncs.com/wod/debian:11 && \
docker run -it --rm \
  -v $PWD/:/go/src/github.com/checkpoint-restore/criu \
  -w /go/src/github.com/checkpoint-restore/criu \
  -e BUILD_VERSION="3.19" \
  -e BUILD_OS="debian11" \
  -e BUILD_ARCH="amd64" \
  registry.cn-qingdao.aliyuncs.com/wod/debian:11 \
  bash .beagle/build11.sh

docker pull registry.cn-qingdao.aliyuncs.com/wod/debian:12 && \
docker run -it --rm \
  -v $PWD/:/go/src/github.com/checkpoint-restore/criu \
  -w /go/src/github.com/checkpoint-restore/criu \
  -e BUILD_VERSION="3.19" \
  -e BUILD_OS="debian12" \
  -e BUILD_ARCH="amd64" \
  registry.cn-qingdao.aliyuncs.com/wod/debian:12 \
  bash .beagle/build.sh
```

## install

```bash
apt install -y ./criu-3.19-debian12-amd64.deb
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
