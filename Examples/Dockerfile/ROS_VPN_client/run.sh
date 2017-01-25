docker build -t ros-openvpn-client ./ && docker run -ti --cap-add=NET_ADMIN --rm --name="ros-openvpn-client" ros-openvpn-client bash -c 'bash' 
