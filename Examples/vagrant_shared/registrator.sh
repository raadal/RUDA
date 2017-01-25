#!/bin/bash
consul_master="$1"
docker rm -f $(hostname)-registrator
docker run -d --restart=always  --name $(hostname)-registrator -h $(hostname) -v /var/run/docker.sock:/tmp/docker.sock gliderlabs/registrator consul://$consul_master:8500
