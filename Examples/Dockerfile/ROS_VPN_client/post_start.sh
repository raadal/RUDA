#!/bin/bash
ROS_DNS=${ROS_DNS_SERVER}

dhclient tap0


while ! ping -c 1 ${ROS_DNS} > /dev/null; do printf .; done ;  wget http://${ROS_DNS}/register.sh &&  bash register.sh;
#echo "nameserver ${ROS_DNS}" > /etc/resolv.conf
