#!/bin/bash

# This setup script will install all required packages and setup all
# system and environment variables required to run ROS and the PR2
# and PbD systems.

clear
echo "RoboSetup Script v0.1 - 9/26/2014"

# Create a function for re-sourcing the .bashrc without creating a new 
# terminal instance. We will use this later...
function re_source {
    xdotool type 'source ~/.bashrc'
    xdotool key Return
}

# Ensure the user has run this script under sudo
if [ "$(whoami)" != "root" ]; then
    echo "Error: This script must be run as root!"
    echo "usage: sudo ./RoboSetup.sh"
    exit 1
fi

# Setup the sources.list and the keys
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu precise main" > /etc/apt/sources.list.d/ros-latest.list'
wget http://packages.ros.org/ros.key -O - | apt-key add -

# Workaround for the Unity bug for Ubuntu 12.04 running xserver-xorg-lts-trusty
apt-get install -y xserver-xorg-lts-saucy
apt-mark hold xserver-xorg-lts-saucy

# Update apt and install ROS Groovy, PR2 packages, and Python packages
export DEBIAN_FRONTEND=noninteractive
apt-get update
#apt-get upgrade -y
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" ros-groovy-desktop-full python2.7 python-pip python-rosinstall ros-groovy-pr2-desktop ros-groovy-pr2-interactive-manipulation ros-groovy-simulator-gazebo ros-groovy-pr2-simulator ros-groovy-openni-launch git xclip ros-groovy-pocketsphinx

# Initialize rosdep
rosdep init
rosdep update

# Environment setup
echo "source /opt/ros/groovy/setup.bash" >> ~/.bashrc
re_source

# Create Workspaces
mkdir ~/rosbuild_ws
cd ~/rosbuild_ws
rosws init . /opt/ros/groovy

mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src
catkin_init_workspace
cd ~/catkin_ws
catkin_make

cat setup.bash >> ~/.bashrc

# Setup git and clone the PbD repo
read -p "What is the name of your computer (ex. 410-daisies)?" MY_COMPUTER_NAME
ssh-keygen -t rsa -C $MY_COMPUTER_NAME
xclip -sel clip < ~/.ssh/id_rsa.pub

echo "A new SSH key has been created and copied to the clipboard..."
echo "Please go to [GitHub > Settings > SSH Keys > Add SSH Key], give the key a title, click in the [Key] field, press Ctrl-V, and save the key."

while true; do
    read -p "Is this complete (y or n)?" yn
    case $yn in
	[Yy]* ) break;;
	[Nn]* ) continue;;
    esac
done

read -p "What is your GitHub username?" GH_USER
cd ~/rosbuild_ws; git clone git@github.com:$GH_USER/pr2_pbd.git
yes | apt-get -y install $(< packages.txt)
pip install -r requirments.txt

# Indicate success!
echo ""
echo "Phew... We made it... And successfully at that!"
echo ""

# See if the user would like us to start up the simulator
while true; do
    read -p "Would you like to start up the PR2 PbD Simulator as a test (y or n)?" yn
    case $yn in
	[Yy]* ) break;;
	[Nn]* ) return;;
    esac
done

roslaunch pr2_pbd_interaction pbd_simulation_stack.launch
