#!/bin/bash
#id1 is any identificator for identifyinmg the call - useful for asynchronous calls
#RUDA in the simulation environment is called 'robot'
CALL_run="id1 robot.motion set_speed [2, -1]"
CALL_stop="id1 robot.motion set_speed [0, 0]"

echo "Make robot run"
echo "$CALL_run" | telnet localhost 4000
sleep 5

echo "Make robot stop"
echo "$CALL_stop" | telnet localhost 4000

