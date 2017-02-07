#!/bin/bash
export IP_ADDR=$(ip addr show dev eth0 | grep 'inet ' | cut -d' ' -f 6); brctl addbr br0; brctl addif br0 tap0; brctl addif br0 eth0; ip addr add $IP_ADDR dev br0; ifconfig eth0 0.0.0.0; ifconfig tap0 0.0.0.0; ifconfig br0 up;
