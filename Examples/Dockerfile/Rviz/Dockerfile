FROM ubuntu:16.04
#FROM osrf/ros:jade-desktop-full

LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
ENV ROS_MASTER_URI http://roscore-kinetic:11311/
ENV ROS_DNS_SERVER=172.25.0.101


RUN apt-get update && apt-get install -y lsb-release openvpn easy-rsa wget ssh-client iputils-ping isc-dhcp-client
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ros-kinetic-ros-base net-tools 

COPY client_default.ovpn /etc/openvpn/client_default.ovpn
COPY post_start.sh  /etc/openvpn/post_start.sh
COPY start_ovpn_client.sh /


#RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y python3-dev python3-yaml python3-setuptools ros-kinetic-rospy ros-kinetic-catkin #morse-simulator
#build morse
#RUN apt-get install -y git build-essential blender telnet vim &&  git clone https://github.com/morse-simulator/morse.git && cd morse && mkdir build && cd build && cmake ../ && make install
#install rospkg
#RUN  git clone https://github.com/ros/rospkg.git && cd rospkg && python3 setup.py install 
#install catkin_pkg
#RUN  git clone https://github.com/ros-infrastructure/catkin_pkg.git -b 0.1.9 && cd catkin_pkg && python3 setup.py install

#RUN wget http://pyyaml.org/download/pyyaml/PyYAML-3.10.tar.gz && tar xvf PyYAML-3.10.tar.gz && cd PyYAML-3.10 && sudo python3 setup.py install

#RUN source /opt/ros/jade/setup.bash

#ENTRYPOINT source /opt/ros/jade/setup.bash; roscore
#ENTRYPOINT /bin/bash

#install other stuff
RUN  apt-get install -y ros-kinetic-control-msgs ros-kinetic-trajectory-msgs ros-kinetic-rviz
RUN useradd -ms /bin/bash newuser



#create and initialize catking workspace
RUN /bin/bash -c 'ls /opt/ros/; source /opt/ros/kinetic/setup.bash; mkdir -p /catkin_ws/src; cd /catkin_ws/src; catkin_init_workspace'
#VOLUME /catkin_ws/src

#build sources from catkin_ws
RUN /bin/bash -c 'ls /catkin_ws/src; source /opt/ros/kinetic/setup.bash; cd /catkin_ws/; catkin_make'
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ros-kinetic-slam-gmapping


#since ROS is a piese of shit when it comes to networking, we have to expose all ports
EXPOSE 1000-65535

#USER newuser
#WORKDIR /home/newuser
CMD /bin/bash -c 'source /opt/ros/kinetic/setup.bash; bash' #morse run /usr/local/share/morse/examples/tutorials/tutorial-1-ros.py'

