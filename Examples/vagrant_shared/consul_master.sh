#!/bin/bash

my_hostname="$1"

docker rm -f $(hostname)-consul
mkdir /consul
docker run -d --restart=always  --name $(hostname)-consul -h $(hostname) -v /consul:/data \
-p $my_hostname:8300:8300 -p $my_hostname:8301:8301 \
-p $my_hostname:8301:8301/udp -p $my_hostname:8302:8302 \
-p $my_hostname:8302:8302/udp -p $my_hostname:8400:8400 \
-p $my_hostname:8500:8500 -p $my_hostname:53:53/udp \
progrium/consul -server -advertise $my_hostname -client 0.0.0.0 -bootstrap -ui-dir /ui
