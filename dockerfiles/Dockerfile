FROM ubuntu:16.04

MAINTAINER Legolas Bloom <zhanhsw@gmail.com>

ENV LANG C.UTF-8

RUN cat /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list

RUN apt-get -y update && \
 apt-get -y install \
   ca-certificates \
   sqlite3 \
   vim \
   supervisor \
   netcat \
   git \
   wget \
    # grafana depends on libfontconfig
   libfontconfig1 \
   --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN mkdir /root/catcher
WORKDIR /root/catcher

# https://portal.influxdata.com/downloads
RUN wget https://dl.influxdata.com/telegraf/releases/telegraf_1.5.3-1_amd64.deb && \
    dpkg -i telegraf_1.5.3-1_amd64.deb && \
    rm telegraf_1.5.3-1_amd64.deb

RUN wget https://dl.influxdata.com/influxdb/releases/influxdb_1.5.1_amd64.deb && \
    dpkg -i influxdb_1.5.1_amd64.deb && \
    rm influxdb_1.5.1_amd64.deb

RUN wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_5.0.4_amd64.deb && \
    dpkg -i grafana_5.0.4_amd64.deb && \
    rm grafana_5.0.4_amd64.deb

EXPOSE 8125:8125/udp
