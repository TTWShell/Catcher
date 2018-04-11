FROM ubuntu:16.04

MAINTAINER Legolas Bloom <zhanhsw@gmail.com>

ENV LANG C.UTF-8

RUN cat /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list

RUN apt-get -y update && \
 apt-get -y install \
   ca-certificates \
   supervisor \
   git \
   wget \
   --no-install-recommends && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# https://portal.influxdata.com/downloads
RUN wget https://dl.influxdata.com/telegraf/releases/telegraf_1.5.3-1_amd64.deb
RUN dpkg -i telegraf_1.5.3-1_amd64.deb && rm telegraf_1.5.3-1_amd64.deb
