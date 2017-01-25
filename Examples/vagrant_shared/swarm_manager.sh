#!/bin/bash
consul_host="$1"
advertise_address="$2"
docker rm -f $(hostname)-smanager
docker run  -d --restart=always  --name $(hostname)-smanager -h $(hostname) -p 4000:4000 swarm manage -H :4000 --replication  --advertise $advertise_address:4000  consul://$consul_host:8500
