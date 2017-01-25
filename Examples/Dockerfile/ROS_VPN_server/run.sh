docker build -t ros-openvpn-ca ./ && docker run -ti --cap-add=NET_ADMIN --rm --name="ros-openvpn-server" ros-openvpn-ca bash -c 'bash' 
