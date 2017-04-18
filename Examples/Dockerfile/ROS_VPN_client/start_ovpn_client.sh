#!/bin/bash

mkdir -p /dev/net ; mknod /dev/net/tun c 10 200; openvpn --cd /etc/openvpn --config /etc/openvpn/client_default.ovpn --dev tap0 --remote $REMOTE  --float
/etc/openvpn/post_start.sh
