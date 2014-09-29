source ~/catkin_ws/devel/setup.bash

# Grabbing IP for ROS_IP
function my_ip() # Get IP adress on ethernet.
{
    MY_IP=$(/sbin/ifconfig eth0 | awk '/inet/ { print $2 } ' |
	sed -e s/addr://)
    echo ${MY_IP:-"Ethernet not connected; ROS_IP will not be set correctly"}
}
echo "Current IP:"; my_ip

# ROS related exports
export ROS_HOSTNAME=localhost
export ROS_MASTER_URI=http://localhost:11311
export ROS_PACKAGE_PATH=~/catkin_ws/:~/rosbuild_ws/:$ROS_PACKAGE_PATH
export ROBOT=sim

# ROS aliases
alias realrobot='unset ROBOT; unset ROS_HOSTNAME; export ROS_MASTER_URI=http://c1:11311; export ROS_IP=$MY_IP'
