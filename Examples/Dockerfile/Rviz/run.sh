#docker build -t morse ./ && docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/dri/:/dev/dri/  morse /bin/bash 

#docker build -t ros-nvidia-6.5 ./ && nvidia-docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/dri/:/dev/dri/ --env="QT_X11_NO_MITSHM=1"   ros-nvidia-6.5 bash -c "rosrun rviz rviz" 

if [ "$1" == ""  ]; then
  echo "Need remote server as a parameter"
  exit 1
fi

. ../docker_env_file.env
echo $ROS_DNS_SERVER


ROS_VERSION="kinetic"
CONTAINER_NAME="rviz-$ROS_VERSION"
ROSCORE_CONTAINER_NAME="dockerfile_roscore-${ROS_VERSION}_1"




#GET_MY_CONTAINER_IP='docker exec -t rviz-kinetic ifconfig eth1 | grep "inet addr" | sed "s/.*addr: *\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\) .*/\1/"'
#
#
#echo ${GET_MY_CONTAINER_IP}
#echo $($GET_MY_CONTAINER_IP)
#
#( while ! docker inspect $CONTAINER_NAME > /dev/null; do sleep 1; done; docker network connect dockerfile_ros_network $CONTAINER_NAME; echo "RViz container registered to ROS network" )&

docker build -t ros-nvidia-6.5 ./ && nvidia-docker run -ti --rm --name="rviz-kinetic" --hostname="rviz" -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/dri/:/dev/dri/ --env="QT_X11_NO_MITSHM=1" --cap-add=NET_ADMIN --rm -e REMOTE="$1" --privileged -e ROS_DNS_SERVER="$ROS_DNS_SERVER"   ros-nvidia-6.5   /bin/bash -c '/start_ovpn_client.sh && su newuser -c "source /opt/ros/kinetic/setup.bash; rosrun rviz rviz "' 

