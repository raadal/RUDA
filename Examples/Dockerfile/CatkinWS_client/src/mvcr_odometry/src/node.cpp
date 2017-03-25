#include "ros/ros.h"
//#include "nav_msgs/Odometry.h"
#include <tf/transform_broadcaster.h>
#include <tf/transform_listener.h>
#include <sstream>
//#include "HAL/API/MovementClient.h"
#include <Poco/SharedPtr.h>
#include <argparser.hh>
#include "Poco/Util/ServerApplication.h"
#include "Poco/Timer.h"
#include "Poco/Delegate.h"
#include "Poco/Net/StreamSocket.h"
#include "Poco/RunnableAdapter.h"
#include "Poco/Runnable.h"
#include "Poco/Net/SocketAddress.h"
#include <cstdlib>
#include <ctype.h>

static volatile double left_encoder= 0;
static volatile double right_encoder= 0;
static volatile double left_speed= 0;
static volatile double right_speed= 0;


static double distance_calibration=0.0;
static double speed_calibration=0.0;
static double turning_calibration=0.0;

//#define ENCODER_STEPS_PER_METER 476110.0
#define ENCODER_STEPS_PER_METER distance_calibration

//TODO: provest merge s verzi ulozenou na  routeru

/*
void onSpeedChanged(HAL::API::Movement::IMovement::StatusChangedArg  & arg){
        std::cout << "Speed: (" << arg.speedLeft << " " << arg.speedRight << ")" << std::endl ;
  ROS_INFO("Left speed: %f", arg.speedLeft);
  //update actual data from encoders
  left_speed= arg.speedLeft;
  right_speed= arg.speedRight;
  left_encoder = arg.posLeft/ENCODER_STEPS_PER_METER;
  right_encoder = arg.posRight/ENCODER_STEPS_PER_METER;
  
   std::cout << "Possition: (" << left_encoder << " " << right_encoder << ")" <<  std::endl;
}*/

//                        waitForTerminationRequest();
//                        client->Movement().StatusChanged -= Poco::delegate(&onSpeedChanged);


class ReadThread : public Poco::Runnable {
  virtual void run() {
    std::cerr << "\n\n\nStarting THREAD \n ************* \n\n\n";
    Poco::Net::StreamSocket client_socket;
    Poco::Net::SocketAddress addr("10.42.0.20:19513");
    client_socket.connect(addr);
    char array[200];
    long long  left_value, right_value;
    int l_sign,r_sign;
    l_sign = r_sign = 1;
    std::string buffer;
    int FSM=0;
    while (1) {
      int received = client_socket.receiveBytes(array,200);
      std::string recv_str(array,received);
      std::cerr << "Received data: "  << recv_str << "\n";
      buffer.append(recv_str);
      left_value = 0;
      right_value = 0;
      std::string::iterator it = buffer.begin();
      for (; it!=buffer.end(); it++) {

      switch (FSM) {
         case 0: //waiting for first {
           if (*it == '{') 
             FSM=1;
            break;
         case 1:
           if (*it == ':')
             FSM=2;
           break;
         case 2:
           if (*it == '-') //note: this is not resitent to sings inside value numbers - oposite side has to be nice not evil ;-)
             l_sign = -1;
           else if (!isdigit(*it)) {
             FSM=3;
             left_value *= l_sign; //we multiply value with the sign variable
           } else
             left_value = left_value*10 + (*it-'0');
           break;          
         case 3:
           if (*it == ':') 
             FSM=4;
           break;
         case 4:
           if (*it == '-') //note: this is not resitent to sings inside value numbers - oposite side has to be nice not evil ;-)
             r_sign = -1;
           else if (!isdigit(*it)) {
             FSM=5;
             if (*it == '}') //if symbol after last number is end of the JSON string
               FSM=0;
             right_value *= r_sign; //we multiply value with the sign variable
           } else
             right_value = right_value*10 + (*it-'0');
           break;
         case 5: //symbols after last number
           if (*it == '}')
             FSM=0;
           break;
       }

       //std::cerr << "FSM debug: " << FSM << " " << *it << " " << left_value <<  " " << right_value << "\n";
       }
       //std::cerr << "\n\n\nFSM val is " << FSM << " " << left_value << " " << right_value << "\n\n\n";
       if (FSM==0) {//update encoder values
          left_encoder = left_value/ENCODER_STEPS_PER_METER;
          right_encoder = right_value/ENCODER_STEPS_PER_METER;
          buffer = buffer.substr(it-buffer.begin(), buffer.size());
          //std::cerr << "Updated values from buffer\n";
       }
       //std::cerr << "Buffer "  << buffer << "\n";

            
    }
  }
};


void help() {
  std::cerr << "Help for odometry node\n";
  std::cerr << "  Calibration parameters: \n";
  std::cerr << "    distance calibration - how many encoder steps are needed for 1 meter of robot movement\n";
  std::cerr << "      argumnet: -distancec, parameter server: /mvcr/encoder_distance_calibration \n";
  std::cerr << "    speed calibration - what is the real speed in m/s of 1.0 encoder speed\n";
  std::cerr << "      argumnet: -speedc, parameter server: /mvcr/encoder_distance_calibration \n";
  std::cerr << "    turning compensation - constant that multiplies angle of turning of the robot computet from encoder values\n";
  std::cerr << "      argumnet: -turnc, parameter server: /mvcr/encoder_turning_compensation \n";

}

/**
 * This tutorial demonstrates simple sending of messages over the ROS system.
 */
int main(int argc, char **argv)
{
  ros::init(argc, argv, "mvcr_odometry");

  ros::NodeHandle n;

  ros::Rate loop_rate(10); //delay between iterations

  tf::TransformListener listener; //listener for transformation between tracks in robot model
 
  ReadThread runnable;
  Poco::Thread thread;
  thread.start(runnable);


  Arg args(argc,argv);
  /* try to obtain parameter throught the commandline */
  std::string distancec=args.GetArgVal("-distancec"); /* calibration of distance measured by encoder to real world - how many encoder steps to meter */
  std::string speedc =args.GetArgVal("-speedc"); /* convertion of encoder speed to real speed - how much is 1.0 of encoder speed in real */
  std::string turnc =args.GetArgVal("-turnc"); /* turning compensation - real turning angle is multiplied by this value */


  n.setParam("/mvcr/encoder_distance_calibration","98765.0");
  n.getParam("/mvcr/encoder_distance_calibration",distancec) ;
  std::cerr << "ENCODER CALIBRATION: " << distancec << "\n";

  /* if there is nothing on the commandline, let's try to get parameters from the parameter server */
  if (distancec == std::string("") && !n.getParam("/mvcr/encoder_distance_calibration",distancec) ) {
    std::cerr <<"Missing distance callibration!\n";
    help();
    return 1;
  }

  if (speedc == std::string("") && !n.getParam("/mvcr/encoder_speed_calibration", speedc)) {
    std::cerr <<"Missing speed calibration!\n";
    help();
    return 1;
  }

  if (turnc == std::string("") && !n.getParam("/mvcr/encoder_turning_compensation",turnc) ) {
    std::cerr <<"Warning: Missing turning compensation value - using default 1.0!\n";
    turnc = "1.0";
    //help();
    //return 1;
  }

  distance_calibration=atof(distancec.c_str());
  speed_calibration=atof(speedc.c_str());
  turning_calibration=atof(turnc.c_str());

  //HAL::API::MovementClient::Ptr client = new HAL::API::MovementClient();
  //client->Movement().StatusChanged += Poco::delegate(&onSpeedChanged);

  ros::Time last_computation = ros::Time::now();

  //initial values
  double initial_pos_x =0.0;
  double initial_pos_y =0.0;
  double initial_rotation =0.0;
  
  
  //last values:
  double last_pos_x = 0;
  double last_pos_y = 0;
  double last_rotation = 0;


  //last encoder values
  double left_encoder_previous=0;
  double right_encoder_previous=0;

  while (ros::ok())
  {
    //get distance between tracks
    double distance_between_tracks = 0;
    tf::StampedTransform transform_in;
    try{
      ros::Time now = ros::Time::now();
      listener.waitForTransform("/left_track_link", "/right_track_link",
                              now, ros::Duration(3.0));
      listener.lookupTransform("/left_track_link", "/right_track_link",
                               now/*ros::Time(0) - jakakoliv posledni transformace */, transform_in);
    }
    catch (tf::TransformException ex){
      ROS_ERROR("%s",ex.what());
      continue;
    }
    distance_between_tracks = transform_in.getOrigin().y();
    //ROS_INFO("iteration"); 
    //compute odometry 
    //according to: http://rossum.sourceforge.net/papers/DiffSteer/

    ros::Time current_time = ros::Time::now();
    double time_sec =  (current_time - last_computation).toSec() ;
    

    //rotation computation
    last_rotation = (right_encoder - left_encoder)/distance_between_tracks + initial_rotation; //vypocitace si rotaci
   std::cerr << "ROTATION "  << last_rotation << "\n";
   // double x_pos =  last_pos_x + ( (right_speed+ left_speed)/2.0 ) * time_sec  * cos(last_rotation);
    
    double x_pos =   last_pos_x + ((left_encoder-left_encoder_previous)+(right_encoder-right_encoder_previous))/2.0   * cos(last_rotation);
    double y_pos =   last_pos_y + ((left_encoder-left_encoder_previous)+(right_encoder-right_encoder_previous))/2.0  * sin(last_rotation);

std::cerr << "last_pos_x: " << last_pos_x << "\n";
    left_encoder_previous = left_encoder;
    right_encoder_previous = right_encoder;

    last_pos_x = x_pos;
    last_pos_y = y_pos;

std::cerr << "DEBUG 1 " << ((left_encoder-left_encoder_previous)+(right_encoder-right_encoder_previous))/2.0 << "\n";
std::cerr << "DEBUG 2 " << cos(last_rotation) << " " << sin(last_rotation)  <<  " " << ((left_encoder-left_encoder_previous)+(right_encoder-right_encoder_previous))/2.0   * cos(last_rotation) <<  " " << x_pos << " -- " << last_pos_x << "\n";
    //TODO: je potreba jeste pricist initial_pos_y a initial_pos_x - ale az k vysledku v prubehu integrace by to delalo chybu


    //double total_distance = (right_encoder + left_encoder) / 2.0;
    
    //last_pos_x = total_distance *cos(last_rotation) + initial_pos_x; //we use updated rotation here
    //last_pos_y = total_distance * sin(last_rotation) + initial_pos_y;


    last_computation = ros::Time::now(); 
   
   
    //broadcast transform from /odom to /base_footprint 
    static tf::TransformBroadcaster br;
    tf::Transform transform;
    tf::Quaternion q;
    q.setRPY(0, 0, last_rotation); //rotation
    
    transform.setRotation(q); //applying rotation to object
    transform.setOrigin( tf::Vector3(last_pos_x, last_pos_y, 0.0) ); //position X,Y - moving origin of the rotation to given coordinates
    

    br.sendTransform(tf::StampedTransform(transform, ros::Time::now(), "/odom", "/base_footprint"));
    //br.sendTransform(tf::StampedTransform(transform, ros::Time::now(), "/odom_combined", "/base_footprint"));

//    br.sendTransform(tf::StampedTransform(transform, ros::Time::now(), "/odom_combined", "/base_footprint"));
    
//    geometry_msgs::Quaternion geom_quat = tf::createQuaternionMsgFromYaw(last_rotation);
//    geometry_msgs::TransformStamped st_transform;
//
//    st_transform.transform.translation.x = last_pos_x;
//    st_transform.transform.translation.y = last_pos_y;
//    st_transform.transform.translation.z = 0;
//    st_transform.transform.rotation = geom_quat;
//    st_transform.header.stamp = ros::Time::now();
//    st_transform.header.frame_id = "/odom_combined";
//    st_transform.child_frame_id = "/base_footprint";

    //br.sendTransform(st_transform);	
//    ROS_INFO("%s", msg.data.c_str());


    ros::spinOnce(); //do the ROS stuff

    loop_rate.sleep(); //wait before  next iteration
  }


  return 0;
}
