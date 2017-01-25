FROM ubuntu:16.04

RUN apt-get update && apt-get install -y lsb-release  wget
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ros-kinetic-ros-base


ADD ssh_key_pair /ssh_key_pair

#RUN source /opt/ros/jade/setup.bash

#ENTRYPOINT source /opt/ros/jade/setup.bash; roscore
#ENTRYPOINT /bin/bash

#CMD /bin/bash -c 'source /opt/ros/kinetic/setup.bash; roscore'
CMD /bin/bash -c 'wget http://${ROS_DNS_SERVER}/register.sh; bash register.sh roscore-kinetic; wget http://${ROS_DNS_SERVER}/register.sh;  bash register.sh;  source /opt/ros/kinetic/setup.bash; roscore'

