from morse.builder import *

class Ruda(GroundRobot):
    """
    A template robot model for Ruda, with a motion controller and a pose sensor.
    """
    def __init__(self, name = None, debug = True):

        # Ruda.blend is located in the data/robots directory
        GroundRobot.__init__(self, 'ruda_sim/robots/Ruda.blend', name)
        self.properties(classpath = "ruda_sim.robots.Ruda.Ruda")

        ###################################
        # Actuators
        ###################################


        # (v,w) motion controller
        # Check here the other available actuators:
        # http://www.openrobots.org/morse/doc/stable/components_library.html#actuators
        self.motion = MotionVW()
        self.append(self.motion)

        # Optionally allow to move the robot with the keyboard
        if debug:
            keyboard = Keyboard()
            keyboard.properties(ControlType = 'Position')
            self.append(keyboard)

        ###################################
        # Sensors
        ###################################

        self.pose = Pose()
        self.append(self.pose)

