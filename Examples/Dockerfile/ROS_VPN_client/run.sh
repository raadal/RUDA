#!/bin/bash

if [ "$1" == ""  ]; then
  echo "Need remote server as a parameter"
  exit 1
fi
. ../docker_env_file.env
echo $ROS_DNS_SERVER
docker build -t ros-openvpn-client ./ && docker run -ti --cap-add=NET_ADMIN --rm -e REMOTE="$1" --privileged -e ROS_DNS_SERVER="$ROS_DNS_SERVER" --name="ros-openvpn-client" ros-openvpn-client bash -c '/start_ovpn_client.sh && bash' 
