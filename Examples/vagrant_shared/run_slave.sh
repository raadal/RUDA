#!/bin/bash

#open firewall connection for docker on node:
iptables -I IN_public_allow 1 -p tcp   --dport 2375 -j ACCEPT
#enable access to consul
iptables -I IN_public_allow 1 -p tcp --dport 8500 -j ACCEPT


#start consul slave
/vagrant/shared/consul_slave.sh  $(/vagrant/shared/get_my_ip.sh) $(/vagrant/shared/get_other_ip.sh master.local)

#start registrator
/vagrant/shared/registrator.sh $(/vagrant/shared/get_other_ip.sh master.local )

#start discovery agent
#/vagrant/shared/swarm_agent.sh $(/vagrant/shared/get_my_ip.sh) $(/vagrant/shared/get_other_ip.sh master.local)
/vagrant/shared/swarm_agent.sh $(/vagrant/shared/get_my_ip.sh) $(/vagrant/shared/get_my_ip.sh) #we can use our own consul instance

#start consul manager
/vagrant/shared/swarm_manager.sh $(/vagrant/shared/get_my_ip.sh) $(/vagrant/shared/get_my_ip.sh)


exit 0
