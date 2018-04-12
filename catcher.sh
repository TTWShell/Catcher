#!/usr/bin/env bash

function echoo {
    echo -e "\033[32m $1 \033[0m"
}

REGISTRY="registry-internal.cn-beijing.aliyuncs.com/ttwshell"
PROJECT_NAME="catcher"
IMG_TAG="latest"
RUNTIME_IMAGE="${REGISTRY}/${PROJECT_NAME}:${IMG_TAG}-runtime"

CUR_DIR=$(pwd)
LOG_DIR="/data/catcher/logs"
INFLUXDB_DIR="/data/catcher/influxdb"
GRAFANA_DIR="/data/catcher/grafana"

function create_data_volume {
    docker inspect ${PROJECT_NAME}-data &> /dev/null
    if [[ "$?" == "1" ]]; then
        docker create --name ${PROJECT_NAME}-data \
            -v ${CUR_DIR}:/root/catcher \
            -v ${LOG_DIR}:/root/catcher/logs \
            -v ${INFLUXDB_DIR}:/root/catcher/influxdb/storage \
            -v ${GRAFANA_DIR}:/root/catcher/grafana/storage \
            hub.c.163.com/library/alpine:3.6 /bin/true
    fi
}

function check_exec_success {
    if [[ "$1" != "0" ]]; then
        echo "ERROR: $2 failed"
        echo "$3"
        exit -1
    fi
}

function build-img {
    command="docker build -t ${PROJECT_NAME}:${IMG_TAG} -f ./dockerfiles/Dockerfile ./dockerfiles $@"
    echoo "${command}" && eval ${command}
}

function release-img {
    docker tag ${PROJECT_NAME}:${IMG_TAG} ${RUNTIME_IMAGE}
    docker push ${RUNTIME_IMAGE}
}

function shell {
    create_data_volume
    docker run --rm -it \
        --volumes-from ${PROJECT_NAME}-data \
        --net=container:${PROJECT_NAME} \
        ${RUNTIME_IMAGE} \
        /bin/bash
}

function start {
    docker kill ${PROJECT_NAME} 2>/dev/null
    docker rm -v ${PROJECT_NAME} 2>/dev/null

    create_data_volume

    docker run -d --name ${PROJECT_NAME} \
        --volumes-from ${PROJECT_NAME}-data \
        --restart=always \
        --net=host \
        --log-opt max-size=10m \
        --log-opt max-file=9 \
        ${RUNTIME_IMAGE} \
        supervisord -c /root/catcher/supervisor/supervisord.conf

    check_exec_success "$?" "start ${PROJECT_NAME} container"
}

function stop {
    docker stop ${PROJECT_NAME} 2>/dev/null
    docker rm -v ${PROJECT_NAME} 2>/dev/null
    docker rm -v ${PROJECT_NAME} 2>/dev/null
}

# ---------------------------- Split
function usage {
    printf "Usage:\n"
    printf "\tbuild-img\tbuild docker image, you can use args of docker build.\n"
    printf "\trelease-img\trelease-img.\n"
    printf "\tshell\t\tshell env.\n"
    printf "\tstart\t\tstart the project.\n"
    printf "\tstop\t\tstop the project.\n"
}

Action=$1

shift
case "${Action}" in
    build-img) build-img $@;;
    release-img) release-img;;
    shell) shell;;
    start) start;;
    stop) stop;;
    *) usage && exit 1 ;;
esac
