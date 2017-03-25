cmake_minimum_required(VERSION 2.8.3)
project(mvcr_odometry)


#include(ExternalProject)
#
#ExternalProject_Add( HALlib
#  PREFIX fit-mbot
#  GIT_REPOSITORY https://github.com/hadzim/fit-mbot.git
#  BUILD_IN_SOURCE
#  BUILD_COMMAND cmake --build .
#  UPDATE_COMMAND git pull
#  INSTALL_COMMAND ""
#)


## Find catkin macros and libraries
## if COMPONENTS list like find_package(catkin REQUIRED COMPONENTS xyz)
## is used, also find other catkin packages
find_package(catkin REQUIRED COMPONENTS
  roscpp
  rospy
  mvcr_hal
  std_msgs
  tf
)

## System dependencies are found with CMake's conventions
# find_package(Boost REQUIRED COMPONENTS system)


## Uncomment this if the package has a setup.py. This macro ensures
## modules and global scripts declared therein get installed
## See http://ros.org/doc/api/catkin/html/user_guide/setup_dot_py.html
# catkin_python_setup()

################################################
## Declare ROS messages, services and actions ##
################################################

## To declare and build messages, services or actions from within this
## package, follow these steps:
## * Let MSG_DEP_SET be the set of packages whose message types you use in
##   your messages/services/actions (e.g. std_msgs, actionlib_msgs, ...).
## * In the file package.xml:
##   * add a build_depend and a run_depend tag for each package in MSG_DEP_SET
##   * If MSG_DEP_SET isn't empty the following dependencies might have been
##     pulled in transitively but can be declared for certainty nonetheless:
##     * add a build_depend tag for "message_generation"
##     * add a run_depend tag for "message_runtime"
## * In this file (CMakeLists.txt):
##   * add "message_generation" and every package in MSG_DEP_SET to
##     find_package(catkin REQUIRED COMPONENTS ...)
##   * add "message_runtime" and every package in MSG_DEP_SET to
##     catkin_package(CATKIN_DEPENDS ...)
##   * uncomment the add_*_files sections below as needed
##     and list every .msg/.srv/.action file to be processed
##   * uncomment the generate_messages entry below
##   * add every package in MSG_DEP_SET to generate_messages(DEPENDENCIES ...)

## Generate messages in the 'msg' folder
# add_message_files(
#   FILES
#   Message1.msg
#   Message2.msg
# )

## Generate services in the 'srv' folder
# add_service_files(
#   FILES
#   Service1.srv
#   Service2.srv
# )

## Generate actions in the 'action' folder
# add_action_files(
#   FILES
#   Action1.action
#   Action2.action
# )

## Generate added messages and services with any dependencies listed here
# generate_messages(
#   DEPENDENCIES
#   std_msgs
# )

###################################
## catkin specific configuration ##
###################################
## The catkin_package macro generates cmake config files for your package
## Declare things to be passed to dependent projects
## INCLUDE_DIRS: uncomment this if you package contains header files
## LIBRARIES: libraries you create in this project that dependent projects also need
## CATKIN_DEPENDS: catkin_packages dependent projects also need
## DEPENDS: system dependencies of this project that dependent projects also need

#ExternalProject_Get_Property(HALlib source_dir)
#ExternalProject_Get_Property(HALlib install_dir)
#include_directories(${install_dir}/include)

#add_dependencies(project_b_exe project_a)

catkin_package(
  INCLUDE_DIRS include 
#${source_dir}/HAL.API/include/ ${source_dir}/TBS/include/ ${source_dir}/TBS.Services/include/ #${include_dir}

#  LIBRARIES mvcr_odometry
#  CATKIN_DEPENDS roscpp rospy std_msgs tf
  DEPENDS HALlib libpoco-dev
)

###########
## Build ##
###########

## Specify additional locations of header files
## Your package locations should be listed before other locations
# include_directories(include)
include_directories(
 include  ${catkin_INCLUDE_DIRS} #${source_dir}/HAL.API/include/ ${source_dir}/TBS/include/ ${source_dir}/TBS.Services/include/ #${include_dir}

)

## Declare a cpp library
# add_library(mvcr_odometry
#   src/${PROJECT_NAME}/mvcr_odometry.cpp
# )

## Declare a cpp executable
 add_executable(mvcr_odometry_node src/node.cpp src/argparser.cpp)

## Add cmake target dependencies of the executable/library
## as an example, message headers may need to be generated before nodes
# add_dependencies(mvcr_odometry_node mvcr_odometry_generate_messages_cpp)

## Specify libraries to link a library or executable target against
 link_directories(${source_dir}/cbuild/ )

#  add_library(TBS STATIC IMPORTED)
#  set_property(TARGET TBS PROPERTY IMPORTED_LOCATION ${source_dir}/cbuild/libTBS.so)
#  add_dependencies(TBS HALlib)

#  add_library(TBS.Services STATIC IMPORTED)
#  set_property(TARGET TBS.Services PROPERTY IMPORTED_LOCATION ${source_dir}/cbuild/libTBS.Services.so)
#  add_dependencies(TBS.Services HALlib)

#  add_library(HAL.API STATIC IMPORTED)
#  set_property(TARGET HAL.API PROPERTY IMPORTED_LOCATION ${source_dir}/cbuild/libHAL.API.so)
#  add_dependencies(HAL.API HALlib)

 target_link_libraries(mvcr_odometry_node
   ${catkin_LIBRARIES} PocoFoundation PocoUtil  TBS  TBS.Services  HAL.API dbus-1
 )

#############
## Install ##
#############

# all install targets should use catkin DESTINATION variables
# See http://ros.org/doc/api/catkin/html/adv_user_guide/variables.html

## Mark executable scripts (Python etc.) for installation
## in contrast to setup.py, you can choose the destination
# install(PROGRAMS
#   scripts/my_python_script
#   DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
# )

## Mark executables and/or libraries for installation
# install(TARGETS mvcr_odometry mvcr_odometry_node
#   ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
#   LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
#   RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
# )

## Mark cpp header files for installation
# install(DIRECTORY include/${PROJECT_NAME}/
#   DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
#   FILES_MATCHING PATTERN "*.h"
#   PATTERN ".svn" EXCLUDE
# )

## Mark other files for installation (e.g. launch and bag files, etc.)
# install(FILES
#   # myfile1
#   # myfile2
#   DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
# )

#############
## Testing ##
#############

## Add gtest based cpp test target and link libraries
# catkin_add_gtest(${PROJECT_NAME}-test test/test_mvcr_odometry.cpp)
# if(TARGET ${PROJECT_NAME}-test)
#   target_link_libraries(${PROJECT_NAME}-test ${PROJECT_NAME})
# endif()

## Add folders to be run by python nosetests
# catkin_add_nosetests(test)
