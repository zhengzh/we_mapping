alias map_saver="rosrun map_server map_saver"

source ~/catkin_cartographer/install_isolated/setup.bash --extend

prefix="roslaunch we_mapping"

function online_mapping() {
    $prefix demo_lidar_2d.launch bag_filename:=$1
}

function offline_mapping() {
    $prefix demo_lidar_2d_offline.launch bag_filenames:=$1
}

function localization() {
    $prefix demo_lidar_2d_pure_localization_bag.launch load_state_filename:=$1.pbstream bag_filename:=$1
}

function pbstream_to_ros_map() {
    rosrun cartographer_ros cartographer_pbstream_to_ros_map -pbstream_filename $1
}

function visualize_pbstream() {
    $prefix visualize_pbstream.launch pbstream_file:=$1
}

function localization_start_trajectory() {
    $prefix lidar_2d_localization_start_trajectory.launch load_state_filename:=$1.pbstream bag_filename:=$1
}

function start_trajectory() {
    if [ $# -eq 0 ]; then
        $prefix start_trajectory.launch
    elif [$# -eq 1]; then
        $prefix start_trajectory.launch $1
    fi
}