#docker build -t morse ./ && docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/dri/:/dev/dri/  morse /bin/bash 

#docker build -t ros-nvidia-6.5 ./ && nvidia-docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/dri/:/dev/dri/ --env="QT_X11_NO_MITSHM=1"   ros-nvidia-6.5 bash -c "rosrun rviz rviz" 

ROS_VERSION="kinetic"
CONTAINER_NAME="morse-$ROS_VERSION"
ROSCORE_CONTAINER_NAME="dockerfile_roscore-${ROS_VERSION}_1"


GET_MY_CONTAINER_IP='docker exec -t morse-kinetic ifconfig eth1 | grep "inet addr" | sed "s/.*addr: *\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\) .*/\1"'

#( while ! docker inspect $CONTAINER_NAME > /dev/null; do sleep 1; done; docker exec $ROSCORE_CONTAINER_NAME bash -c 'echo "$($GET_MY_CONTAINER_IP)  morse" >> /etc/hosts'; docker network connect dockerfile_ros_network $CONTAINER_NAME; echo "MORSE container registered to ROS network" )&

( while ! docker inspect $CONTAINER_NAME > /dev/null; do sleep 1; done; docker network connect dockerfile_ros_network $CONTAINER_NAME; echo "MORSE container registered to ROS network" )&
ROS_DNS_SERVER=172.25.0.101

#docker build -t ros-nvidia-6.5 ./ && nvidia-docker run -ti --rm --name="${CONTAINER_NAME}" --hostname="morse" -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/dri/:/dev/dri/ -v $PWD/sources:/sources -v $PWD/catkin_ws_src:/catkin_ws/src --env="QT_X11_NO_MITSHM=1"   ros-nvidia-6.5  bash -c "su newuser -c '  source /opt/ros/kinetic/setup.bash; mkdir -p ~/.morse/; cp /sources/morse_config ~/.morse/config; morse run ruda_sim' "   #/usr/local/share/morse/examples/tutorials/tutorial-1-ros.py"

docker build -t ros-nvidia-6.5 ./ && nvidia-docker run -ti --rm --name="${CONTAINER_NAME}" --hostname="morse" --dns=${ROS_DNS_SERVER} -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/dri/:/dev/dri/ -v $PWD/sources:/sources -v $PWD/catkin_ws_src:/catkin_ws/src --env="QT_X11_NO_MITSHM=1"   ros-nvidia-6.5  bash -c "while ! ls /wait_for_registration.sh; do echo 'Wait for COPY'; sleep 0.5; done; chmod +x /wait_for_registration.sh; bash /wait_for_registration.sh > /tmp/MY_IP ; echo My_IP_IS_$( cat /tmp/MY_IP) >&2 ; wget http://${ROS_DNS_SERVER}/register.sh;  bash register.sh morse \$(ip addr  show eth1 | grep 'inet ' | sed 's/.* \([0-9][0-9]*\.[0-9][0-9]*.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/') ; while ! ping -c 1 roscore-kinetic; do printf 'waiting for DNS '; sleep 0.5; done ; su newuser -c '  source /opt/ros/kinetic/setup.bash; mkdir -p ~/.morse/; cp /sources/morse_config ~/.morse/config; morse run ruda_sim' "   #/usr/local/share/morse/examples/tutorials/tutorial-1-ros.py"

#docker build -t ros-nvidia-6.5 ./ && nvidia-docker run -ti --rm --name="${CONTAINER_NAME}" --hostname="morse" --dns=${ROS_DNS_SERVER} -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/dri/:/dev/dri/ -v $PWD/sources:/sources -v $PWD/catkin_ws_src:/catkin_ws/src --env="QT_X11_NO_MITSHM=1"   ros-nvidia-6.5  bash -c "su newuser -c '  source /opt/ros/kinetic/setup.bash; mkdir -p ~/.morse/; cp /sources/morse_config ~/.morse/config; morse run ruda_sim' "   #/usr/local/share/morse/examples/tutorials/tutorial-1-ros.py"


