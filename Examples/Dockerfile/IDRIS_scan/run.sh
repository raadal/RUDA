#docker build -t morse ./ && docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/dri/:/dev/dri/  morse /bin/bash 

#docker build -t ros-nvidia-6.5 ./ && nvidia-docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/dri/:/dev/dri/ --env="QT_X11_NO_MITSHM=1"   ros-nvidia-6.5 bash -c "rosrun rviz rviz" 
docker build -t ros-nvidia-6.5-idris-scan ./ && nvidia-docker run -ti --rm --name="ros-nvidia-IDRIS-scan" -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/dri/:/dev/dri/ -v $PWD/sources:/sources --env="QT_X11_NO_MITSHM=1"   ros-nvidia-6.5-idris-scan bash -c 'source /opt/ros/jade/setup.bash; bash'  #morse run /usr/local/share/morse/examples/tutorials/tutorial-1-ros.py'
