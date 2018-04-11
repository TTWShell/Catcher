#!/usr/bin/env bash

function echoo {
    echo -e "\033[32m $1 \033[0m"
}

REGISTRY="registry-internal.cn-beijing.aliyuncs.com/ttwshell"
IMG_NAME="catcher"
IMG_TAG="latest"
RUNTIME_IMAGE="${REGISTRY}/${IMG_NAME}:${IMG_TAG}-runtime"

CUR_DIR=${pwd}

function create_data_volume {
    docker inspect ${IMG_NAME}-data &> /dev/null
    if [[ "$?" == "1" ]]; then
        docker create --name ${IMG_NAME}-data \
            -v ${CUR_DIR}:/root \
            hub.c.163.com/library/alpine:3.6 /bin/true
    fi
}

function build-img {
    command="docker build -t ${IMG_NAME}:${IMG_TAG} -f ./dockerfiles/Dockerfile ./dockerfiles $@"
    echoo "${command}" && eval ${command}
}

function release-img {
    docker tag ${IMG_NAME}:${IMG_TAG} ${RUNTIME_IMAGE}
    docker push ${RUNTIME_IMAGE}
}

function shell {
    create_data_volume
    docker run --rm -it \
    --volumes-from ${IMG_NAME}-data \
    --net=host \
    ${RUNTIME_IMAGE} \
    /bin/bash
}


# ---------------------------- Split
function usage {
    printf "Usage:\n"
    printf "\tbuild-img\tbuild docker image, you can use args of docker build.\n"
    printf "\trelease-img\trelease-img.\n"
    printf "\tshell\t\tshell env.\n"
}

Action=$1

shift
case "${Action}" in
    build-img) build-img $@;;
    release-img) release-img;;
    shell) shell;;
    *) usage && exit 1 ;;
esac
