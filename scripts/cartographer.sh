set_env="source ~/catkin_cartographer/install_isolated/setup.bash"
mapping_launch_filename="lidar_2d_localization_start_trajectory"
start_trajectory_launch_filename="start_trajectory.launch"
start_localization_launch_filename="lidar_2d_localization_start_trajectory.launch"
enviroment="~/catkin_cartographer/install_isolated/setup.bash"
launch_prefix="roslaunch we_mapping"
tmux_name="we_mapping"

# load_state_filename="/home/zh/Downloads/b2-2016-04-05-14-44-52.bag.pbstream"
# bag_filename="/home/zh/Downloads/b2-2016-04-27-12-31-41.bag"
# initial_pose="{ to_trajectory_id=0,relative_pose={translation={10,10,0},rotation={0.0,0.0,0.0}}}"
bag_filename=$1
load_state_filename="$1.pbstream"
initial_pose=$2

echo $initial_pose
function localization_command() {
    state_filename=$1
    bag_filename=$2
    echo "$launch_prefix $start_localization_launch_filename load_state_filename:=$state_filename bag_filename:=$bag_filename"
}

# echo $(localization_command $start_localization_launch_filename $state_filename $bag_filename)
# echo "'$x'"

function start_trajectory_command() {
    initial_pose=$1
    echo "$launch_prefix $start_trajectory_launch_filename initial_pose:='$initial_pose'"
}

# echo $(start_trajectory "{ to_trajectory_id=0, relative_pose={translation={10, 10, 0},rotation={0.0,0.0,0.0} }}")

function tmux_wrapper() {
    echo "tmux new-window -t $tmux_name \"source $enviroment; $1\" \; detach \;"
}

function start_localization() {
    tmux kill-session -t $tmux_name
    tmux new-session -s $tmux_name -d
    localization="$(localization_command "$1" "$2")"
    start_trajectory="$(start_trajectory_command "$3")"
    eval $(tmux_wrapper "$localization")
    sleep 1
    eval "$(tmux_wrapper "$start_trajectory")"
}
function te(){
    echo "ls -lh"
}
# $(echo "ls -lh")
# echo $test
start_localization "$load_state_filename" "$bag_filename" "$initial_pose"

tmux list-sessions

# roslaunch cartographer_ros demo_backpack_2d_localization_start_trajectory.launch \
# load_state_filename:=/home/zh/Downloads/b2-2016-04-05-14-44-52.bag.pbstream \
# bag_filename:=/home/zh/Downloads/b2-2016-04-27-12-31-41.bag"

# rosrun cartographer_ros cartographer_start_trajectory \ 
# -configuration_directory="$(rospack find cartographer_ros)/configuration_files" \
# -configuration_basename="$backpack_2d_localization.lua"  \
# --initial_pose="{ to_trajectory_id=0, relative_pose={translation={10, 10, 0},rotation={0.0,0.0,0.0} }}"