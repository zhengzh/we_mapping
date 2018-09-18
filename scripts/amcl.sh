
map="$1"
tmux_name="amcl"
launch_prefix="roslaunch we_mapping"
enviroment="~/catkin_navigation/devel/setup.bash"

function tmux_wrapper() {
    echo "tmux new-window -t $tmux_name \"source $enviroment; $1\" \; detach \;"
}

function start_amcl() {
    tmux kill-session -t $tmux_name
    tmux kill-session -t $tmux_name
    tmux new-session -s $tmux_name -d
    if [ -z "$map" ]; then
        eval $(tmux_wrapper "$launch_prefix we_amcl.launch")
    else
    
        eval $(tmux_wrapper "$launch_prefix we_amcl.launch map_file:=$map")        
    fi
}

start_amcl
tmux list-sessions