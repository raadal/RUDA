FROM ubuntu

RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
RUN apt-get update
RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ros-jade-ros-base 

#build tools
RUN sudo apt-get update && apt-get install -y build-essential ros-jade-tf2-msgs ros-jade-tf libdbus-1-dev libopencv-dev ros-jade-urdf ros-jade-urdf-parser-plugin liburdfdom-dev ros-jade-xacro libsdl-dev ros-jade-robot-state-publisher

#add entrypoint launchfile
RUN sudo mkdir /launch
ADD entrypoint.launch /launch/entrypoint.launch

#create and initialize catking workspace
RUN /bin/bash -c 'ls /opt/ros/; source /opt/ros/jade/setup.bash; mkdir -p /catkin_ws/src; cd /catkin_ws/src; catkin_init_workspace'
VOLUME /catkin_ws/src/*

#build sources from catkin_ws
RUN /bin/bash -c 'ls /catkin_ws/src; source /opt/ros/jade/setup.bash; cd /catkin_ws/; catkin_make'
#RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ros-jade-slam-gmapping

#RUN source /opt/ros/jade/setup.bash

#ENTRYPOINT source /opt/ros/jade/setup.bash; roscore
#ENTRYPOINT /bin/bash

CMD /bin/bash -c 'ls /catkin_ws/src/ >&2; source /catkin_ws/devel/setup.bash; cd /catkin_ws; catkin_make; roslaunch /launch/entrypoint.launch'
#CMD /bin/bash -c 'ls /catkin_ws/src/ >&2'

