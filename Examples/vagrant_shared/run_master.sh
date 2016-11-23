#!/bin/bash

#open firewall connection for docker on node:
iptables -I IN_public_allow 1 -p tcp   --dport 2375 -j ACCEPT
#enable access to consul:
iptables -I IN_public_allow 1 -p tcp --dport 8500 -j ACCEPT

#pull docker images
/vagrant/shared/docker_pull_images.sh

#start consul master
/vagrant/shared/consul_master.sh $(/vagrant/shared/get_my_ip.sh)

#wait for consul to be active:
#while ! curl http://$(/vagrant/shared/get_other_ip.sh node-c7-a.local):8500; do 
#  sleep 1;
#done

#start registrator
/vagrant/shared/registrator.sh $(/vagrant/shared/get_my_ip.sh )

#start discovery agent
/vagrant/shared/swarm_agent.sh $(/vagrant/shared/get_my_ip.sh) $(/vagrant/shared/get_my_ip.sh)

#start consul manager
/vagrant/shared/swarm_manager.sh $(/vagrant/shared/get_my_ip.sh) $(/vagrant/shared/get_my_ip.sh)

exit 0
