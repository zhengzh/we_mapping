alias map_saver="rosrun map_server map_saver"

function online_mapping() {
    roslaunch we_mapping demo_lidar_2d.launch bag_filename:=$1
}

function offline_mapping() {
    roslaunch we_mapping demo_lidar_2d_offline.launch bag_filenames:=$1
}

function localization() {

}
function pbstream_to_ros_map() {
    rosrun cartographer_ros cartographer_pbstream_to_ros_map $1
}
