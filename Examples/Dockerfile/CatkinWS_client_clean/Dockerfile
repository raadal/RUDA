FROM ubuntu:16.04

RUN apt-get update && apt-get install -y lsb-release wget
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ros-kinetic-ros-base

#build tools
RUN apt-get update && apt-get install -y build-essential ros-kinetic-tf2-msgs ros-kinetic-tf libdbus-1-dev libopencv-dev ros-kinetic-urdf ros-kinetic-urdf-parser-plugin liburdfdom-dev ros-kinetic-xacro libsdl-dev ros-kinetic-robot-state-publisher

#add entrypoint launchfile
RUN mkdir /launch
ADD entrypoint.launch /launch/entrypoint.launch

#create and initialize catking workspace
RUN /bin/bash -c 'ls /opt/ros/; source /opt/ros/kinetic/setup.bash; mkdir -p /catkin_ws/src; cd /catkin_ws/src; catkin_init_workspace'
VOLUME /catkin_ws/src

#build sources from catkin_ws
RUN /bin/bash -c 'ls /catkin_ws/src; source /opt/ros/kinetic/setup.bash; cd /catkin_ws/; catkin_make'
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ros-kinetic-slam-gmapping



#CMD /bin/bash -c 'ls /catkin_ws/src/ >&2; source /catkin_ws/devel/setup.bash; cd /catkin_ws; catkin_make >&2; while true; do sleep 10; done'
CMD /bin/bash -c 'wget http://${ROS_DNS_SERVER}/register.sh;  bash register.sh; ls /catkin_ws/src/ >&2; source /catkin_ws/devel/setup.bash; cd /catkin_ws; catkin_make >&2; while true; do sleep 10; done'

