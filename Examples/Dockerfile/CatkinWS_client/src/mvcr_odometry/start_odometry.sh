#!/bin/sh

export DISPLAY=":0"

LD_LIBRARY_PATH=~/catkin_ws/build/mvcr_odometry/fit-mbot/src/HALlib/cbuild/:/home/ros/catkin_ws/devel/lib:/opt/ros/hydro/lib; rosrun mvcr_odometry mvcr_odometry_node
