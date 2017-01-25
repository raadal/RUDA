FROM ubuntu:16.04

RUN apt-get update && apt-get install -y lsb-release wget
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ros-kinetic-ros-base

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ros-kinetic-slam-gmapping

#CMD /bin/bash -c 'source /opt/ros/kinetic/setup.bash; rosrun gmapping slam_gmapping'
CMD /bin/bash -c 'wget http://${ROS_DNS_SERVER}/register.sh;  bash register.sh;  source /opt/ros/kinetic/setup.bash; rosrun gmapping slam_gmapping'

