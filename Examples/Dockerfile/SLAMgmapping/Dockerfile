FROM ubuntu:14.04

RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
RUN apt-get update
RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ros-jade-ros-base



RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ros-jade-slam-gmapping

#RUN source /opt/ros/jade/setup.bash

#ENTRYPOINT source /opt/ros/jade/setup.bash; roscore
#ENTRYPOINT /bin/bash
CMD /bin/bash -c 'source /opt/ros/jade/setup.bash; rosrun gmapping slam_gmapping'

