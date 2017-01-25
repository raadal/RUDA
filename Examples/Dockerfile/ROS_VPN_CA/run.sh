docker build -t ros-openvpn-ca ./ && docker run -ti --cap-add=NET_ADMIN --rm --name="ros-openvpn-ca" -v $PWD/ca_root:/openvpn-ca ros-openvpn-ca bash -c 'bash' 
