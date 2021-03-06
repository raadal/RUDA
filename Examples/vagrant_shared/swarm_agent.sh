#!/bin/bash
my_address="$1"
consul_server="$2"
docker rm -f $(hostname)-sagent
docker run -d --restart=always --name $(hostname)-sagent -h $(hostname) swarm join --advertise=$my_address:2375 consul://$consul_server:8500
