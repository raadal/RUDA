#! /usr/bin/env morseexec

""" Basic MORSE simulation scene for <ruda_sim> environment

Feel free to edit this template as you like!
"""

from morse.builder import *
from ruda_sim.builder.robots import Ruda


# Add the MORSE mascott, MORSY.
# Out-the-box available robots are listed here:
# http://www.openrobots.org/morse/doc/stable/components_library.html
#
# 'morse add robot <name> ruda_sim' can help you to build custom robots.
robot = Ruda()

# The list of the main methods to manipulate your components
# is here: http://www.openrobots.org/morse/doc/stable/user/builder_overview.html
robot.translate(1.0, 0.0, 0.0)
robot.rotate(0.0, 0.0, 3.5)

# Add a motion controller
# Check here the other available actuators:
# http://www.openrobots.org/morse/doc/stable/components_library.html#actuators
#
# 'morse add actuator <name> ruda_sim' can help you with the creation of a custom
# actuator.
motion = MotionVW()
robot.append(motion)


# Add a keyboard controller to move the robot with arrow keys.
keyboard = Keyboard()
robot.append(keyboard)
keyboard.properties(ControlType = 'Position')

# Add a pose sensor that exports the current location and orientation
# of the robot in the world frame
# Check here the other available actuators:
# http://www.openrobots.org/morse/doc/stable/components_library.html#sensors
#
# 'morse add sensor <name> ruda_sim' can help you with the creation of a custom
# sensor.
pose = Pose()
robot.append(pose)


#LIDAR
lidar = Sick()
#lidar.properties(resolution = 5) #what do these parameters mean?
#lidar.properties(scan_window=90)
lidar.properties(laser_range= 30.0)
robot.append(lidar)


#cameras:
# creates a new instance of the sensor
videocamera_front = VideoCamera()
videocamera_front.translate(0.6, 0, 0)
videocamera_rear = VideoCamera()
videocamera_rear.translate(-0.6, 0, 0)
videocamera_rear.rotate(3.1415927, 0,  0)

robot.append(videocamera_front)
robot.append(videocamera_rear)


# To ease development and debugging, we add a socket interface to our robot.
#
# Check here: http://www.openrobots.org/morse/doc/stable/user/integration.html 
# the other available interfaces (like ROS, YARP...)
robot.add_default_interface('socket')
pose.add_stream('socket')
pose.add_service('socket')
motion.add_service('socket')



# Add default interface for our robot's components
robot.add_default_interface('ros')


# set 'fastmode' to True to switch to wireframe mode
env = Environment('land-1/trees', fastmode = False)
env.set_camera_location([-18.0, -6.7, 10.8])
env.set_camera_rotation([1.09, 0, -1.14])

