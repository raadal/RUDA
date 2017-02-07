#!/bin/bash
ROS_DNS=${ROS_DNS_SERVER}
while ! ping -c 1 ${ROS_DNS}; do printf .; done ;  wget http://${ROS_DNS}/register.sh &&  bash register.sh;
echo "nameserver ${ROS_DNS}" > /etc/resolv.conf
