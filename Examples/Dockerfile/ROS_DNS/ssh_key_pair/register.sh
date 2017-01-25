#!/bin/bash




apt-get install -y openssh-client
wget http://${ROS_DNS_SERVER}/dns_key

if [ "$1" == "" ]; then
  HOSTNAME_VAL=$(hostname)
else
  HOSTNAME_VAL="$1"
fi

if [ "$2" == "" ]; then
  MY_IP=$(ip addr  show eth0 | grep 'inet ' | sed 's/.* \([0-9][0-9]*\.[0-9][0-9]*.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/')
else 
  MY_IP="$2"
fi



RECORD="${MY_IP}  ${HOSTNAME_VAL}"
chmod 200 dns_key
ssh  ssh_user@${ROS_DNS_SERVER} -i dns_key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -C "echo '${RECORD}' >> /etc/hosts.dnsmasq; echo '${RECORD}' > /tmp/dns_restart_fifo"
rm dns_key


NEW_RESOLV_CONF="search lan
nameserver ${ROS_DNS_SERVER}
options ndots:0"

#echo "${NEW_RESOLV_CONF}" > /etc/resolv.conf



