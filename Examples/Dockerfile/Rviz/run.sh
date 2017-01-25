#docker build -t morse ./ && docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/dri/:/dev/dri/  morse /bin/bash 

#docker build -t ros-nvidia-6.5 ./ && nvidia-docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/dri/:/dev/dri/ --env="QT_X11_NO_MITSHM=1"   ros-nvidia-6.5 bash -c "rosrun rviz rviz" 

ROS_VERSION="kinetic"
CONTAINER_NAME="rviz-$ROS_VERSION"
ROSCORE_CONTAINER_NAME="dockerfile_roscore-${ROS_VERSION}_1"


GET_MY_CONTAINER_IP='docker exec -t rviz-kinetic ifconfig eth1 | grep "inet addr" | sed "s/.*addr: *\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\) .*/\1/"'


echo ${GET_MY_CONTAINER_IP}
echo $($GET_MY_CONTAINER_IP)

#( while ! docker inspect $CONTAINER_NAME > /dev/null; do sleep 1; done; docker exec $ROSCORE_CONTAINER_NAME bash -c 'echo "$($GET_MY_CONTAINER_IP)  rviz" >> /etc/hosts'; docker network connect dockerfile_ros_network $CONTAINER_NAME; echo "RViz container registered to ROS network" )&

#docker build -t ros-nvidia-6.5 ./ && nvidia-docker run -ti --rm --name="rviz-kinetic" --hostname="rviz" -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/dri/:/dev/dri/ --env="QT_X11_NO_MITSHM=1"   ros-nvidia-6.5 su newuser -c "source /opt/ros/kinetic/setup.bash; rosrun rviz rviz " #/usr/local/share/morse/examples/tutorials/tutorial-1-ros.py"



