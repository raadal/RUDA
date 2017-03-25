CHYBA: spatne pouzity build system - nutno pred spustenim zadat:
	POZOR: pri kopirovani do existujiciho workspace a prepisu balicku tehoz jmena se stane, ze vypadne stahovani GIT repozitare. Pokud nefunguje stahovani GIT repozitare, je potreba zkopirovat cely workspace a ten pouzit a prepsat jim cely puvodni (tehoz jmena).
export LD_LIBRARY_PATH=~/catkin_ws/build/mvcr_odometry/fit-mbot/src/HALlib/cbuild/:/home/ros/catkin_ws/devel/lib:/opt/ros/hydro/lib
je potreba nainstalovat balik: dbus-x11 (sudo apt-get install dbus-x11)


Beh na pocitaci robota:
======================
-spusteni serveru a klienta HAL:
	Je potreba je spustit v chrootu s ROSem, jinak HAL nekomunikuje (NUTNO VYRESIT)
	V adresari ~/catkin_ws/build/mvcr_odometry/fit-mbot/src/HALlib/cbuild se nachazeji binarky serveru, klienta a observeru 
	cd ~/catkin_ws/build/mvcr_odometry/fit-mbot/src/HALlib/cbuild
	./bin.HAL.Server -mode=real 
	V jinem terminalu:
	./bin.HAL.Client 
-spusteni odometrie:
	roslaunch mvcr_robot_description upload_robot.launch #natahne popis robota
	rosrun mvcr_odometry mvcr_odometry_node #spusti nod s odometrii
-pocitac nepodporuje GLX -> je nutne spoustet na vzdalene stanici:
	v /etc/hosts na pocitaci robota je potreba pridat zaznam pro vzdalenou stanici - aby ji PC robota nasel jmenem (tvar: ip_adresa jmeno) (napr: 192.168.1.122 stanice)
	v /etc/hosts vzdalene stanice je potreba pridat zaznam pro PC robota aby ho stanice nasla jmenem (napr: 192.168.1.122 pcrobot)
	na stanici vyexportovat ROS_MASTER_URI:  export ROS_MASTER_URI="http://192.168.1.121:11311"  (pripadne lze asi i pouzit jmeno pcrobot misto IP adresy)
	nyni je mozne na stanici pustit rviz: rosrun rviz rviz

	
