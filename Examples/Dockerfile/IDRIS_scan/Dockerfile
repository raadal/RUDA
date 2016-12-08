FROM ubuntu:14.04
#FROM osrf/ros:jade-desktop-full

LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
ENV ROS_MASTER_URI http://172.17.0.1:11311/


RUN apt-get update && apt-get install  -y lsb-release
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ros-jade-ros-base 



RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y git python3-dev python3-yaml python3-setuptools ros-jade-rospy software-properties-common #morse-simulator
#build morse
#RUN apt-get install -y git build-essential blender &&  git clone https://github.com/morse-simulator/morse.git && cd morse && mkdir build && cd build && cmake ../ && make install
#install rospkg
RUN  git clone https://github.com/ros/rospkg.git && cd rospkg && python3 setup.py install 
#install catkin_pkg
RUN  git clone https://github.com/ros-infrastructure/catkin_pkg.git -b 0.1.9 && cd catkin_pkg && python3 setup.py install

#RUN wget http://pyyaml.org/download/pyyaml/PyYAML-3.10.tar.gz && tar xvf PyYAML-3.10.tar.gz && cd PyYAML-3.10 && sudo python3 setup.py install

#RUN source /opt/ros/jade/setup.bash

#ENTRYPOINT source /opt/ros/jade/setup.bash; roscore
#ENTRYPOINT /bin/bash

#install other stuff
RUN apt-get install -y libtool subversion autoconf-archive g++ libgsl0-dev libpng-dev libjpeg-dev  libv4l-dev openjdk-7-jre libdc1394-22-dev qt4-dev-tools libqt4-dev libqt4-core libqt4-gui libgps-dev python-gps gpsd-clients  #libgtk+2.0-dev 
#symlink to linux/videodev.h
RUN ln -s  /usr/include/libv4l-plugin.h /usr/include/linux/videodev.h
RUN useradd -ms /bin/bash newuser

#USER newuser
#WORKDIR /home/newuser
CMD /bin/bash -c 'source /opt/ros/jade/setup.bash; bash' #morse run /usr/local/share/morse/examples/tutorials/tutorial-1-ros.py'

