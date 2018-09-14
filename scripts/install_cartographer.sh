sudo apt-get update

# Install CMake 3.2 for Ubuntu Trusty and Debian Jessie.
sudo apt-get install lsb-release -y
if [[ "$(lsb_release -sc)" = "trusty" ]]
then
  sudo apt-get install cmake3 -y
elif [[ "$(lsb_release -sc)" = "jessie" ]]
then
  sudo sh -c "echo 'deb http://ftp.debian.org/debian jessie-backports main' >> /etc/apt/sources.list"
  sudo apt-get update
  sudo apt-get -t jessie-backports install cmake -y
else
  sudo apt-get install cmake -y
fi

catkin_ws_directory="~/catkin_cartographer"
devel_directory=${catkin_ws_directory}/devel_isolated
build_directory=${catkin_ws_directory}/build_isolated
install_directory=${catkin_ws_directory}/install_isolated

sudo apt-get install -y \
    g++ \
    git \
    google-mock \
    libboost-all-dev \
    libcairo2-dev \
    libeigen3-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    liblua5.2-dev \
    libsuitesparse-dev \
    ninja-build \
    python-sphinx

sudo apt-get install -y python-wstool python-rosdep ninja-build

mkdir ${catkin_ws_directory}
cd ${catkin_ws_directory}
mkdir src
wstool init src

wstool merge -t src https://raw.githubusercontent.com/googlecartographer/cartographer_ros/master/cartographer_ros.rosinstall
wstool update -t src

# Install proto3.
src/cartographer/scripts/install_proto3.sh

# Install deb dependencies.
# The command 'sudo rosdep init' will print an error if you have already
# executed it since installing ROS. This error can be ignored.

# Build and install.
rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y
catkin_make_isolated --install --use-ninja
source install_isolated/setup.bash
# alias build="rm ${devel_directory} -rf; rm ${install_directory} -rf; rm ${build_directory} -rf; catkin_make_isolated --install --use-ninja"