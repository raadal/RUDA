FROM ubuntu:16.04

RUN apt-get update && apt-get install -y lsb-release 
#RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
#RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
RUN apt-get update
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ros-kinetic-ros-base
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y dnsmasq lighttpd openssh-server 

COPY dnsmasq.conf /etc/dnsmasq.conf 
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY ssh_key_pair/ /ssh_key_pair/

#prepare configugs and data directories for lighttpd and dnsmasq
RUN chown -R www-data:www-data /ssh_key_pair/; touch /etc/hosts.dnsmasq; 
#add ssh_user
RUN useradd ssh_user; mkdir /home/ssh_user/; chown -R ssh_user:ssh_user /home/ssh_user/; chown ssh_user:root /etc/hosts.dnsmasq;  mkfifo /tmp/dns_restart_fifo ; chown ssh_user:root /tmp/dns_restart_fifo 
#prepare ssh access for ssh_user
RUN su ssh_user -c "mkdir ~/.ssh; chmod 700 ~/.ssh; touch ~/.ssh/authorized_keys; chmod 600 ~/.ssh/authorized_keys; cat /ssh_key_pair/dns_key.pub >> ~/.ssh/authorized_keys "



#RUN source /opt/ros/jade/setup.bash

#ENTRYPOINT source /opt/ros/jade/setup.bash; roscore
#ENTRYPOINT /bin/bash
CMD /bin/bash -c 'printf "" > /etc/hosts.dnsmasq; /etc/init.d/lighttpd start ; /etc/init.d/dnsmasq start; /etc/init.d/ssh restart; while true; do cat /tmp/dns_restart_fifo >&2 ; /etc/init.d/dnsmasq restart; done'

