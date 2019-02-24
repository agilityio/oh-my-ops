_do_plugin "proj"

_do_log_level_warn "tmux"

# ==============================================================================
# Proj plugin integration
# ==============================================================================


# Initializes tmux supports for the specified repository.
#
function _do_tmux_repo_init() {
    local proj_dir=$1
    local repo=$2

    if ! _do_tmux_repo_enabled "${proj_dir}" "${repo}"; then 
        return
    fi

    _do_log_debug "tmux" "Initializes tmux integration for $repo"

    _do_repo_alias_add $proj_dir $repo "tmux" "help start stop" 
}


# Runs any sphinx command in docker.
# Arguments:
#   1. repo: The repository name.
#
function _do_sphinx_repo_cmd() {
    local proj_dir=$1
    shift

    local repo=$1
    shift

    local daemon_opts=""

    if [ "$1" == "--daemon" ]; then 
        daemon_opts="-d"
        shift
    fi 

}


# Displays helps for the specified repository.
#
function _do_tmux_repo_help() {
    local proj_dir=$1
    local repo=$2

    echo "  ${repo}-tmux-help: See tmux command helps"
}

# This function runs tmux section for the given repository.
# Arguments:
#   1. repo: The repository name. E.g, `hello-service`
#   2. config_file (optional): The location to load the tmux config file.
#       The default would be `.tmux` at the repository directory.
#
# It is important to note that, if the tmux have been run before,
# this will just reopen that session instead of running the new one.
#
function _do_tmux_repo_start() {
    local proj_dir=$1
    local repo=$2

    if ! _do_tmux_repo_enabled "${proj_dir}" "${repo}"; then 
        return
    fi

    _do_print_header_1 "Runs tmux for $repo"

    if tmux attach-session -t "$repo" &> /dev/null; then
        # Successfully attach to the previous session. Stop!
        return
    fi

    # Sets to the default config file.
    local config_file="$proj_dir/$repo/.tmux"

    if [ ! -f $config_file ]; then
        _do_log_error "tmux" "Error: $config_file not found!"
        return 1
    fi

    # Internal Field Separator. As man bash says, it. is used for word
    # splitting after expansion and to split lines into words with the
    # read builtin command.
    local IFS=''

    # Creates a new window session
    tmux new-session -d -s "${repo}" -x 2000 -y 2000
    tmux select-layout "tiled"

    # Show tmux status
    _do_tmux_set_option pane-border-status bottom
    _do_tmux_set_option pane-border-bg colour235
    _do_tmux_set_option pane-border-fg colour238
    _do_tmux_set_option pane-active-border-bg colour236
    _do_tmux_set_option pane-active-border-fg colour51

    # Sets the status title
    _do_tmux_set_option pane-border-format '#P: #(cd #{pane_current_path}; git rev-parse --show-toplevel | xargs basename)'

    # Makes the status update more often.
    _do_tmux_set_option status-interval 5
    _do_tmux_send_activate_cmd


    # Parse all lines in the layout file
    cat $config_file | while read line; do
        # Reads in and clean up the line. Notes that line start with `#`
        # will be removed. This will also trim the leading and trailing spaces.
        line=`echo "$line" | sed -e 's/#.*$//g' -e 's/[[:blank:]]*$//' -e 's/^[[:blank:]]*//'`

        # The line is empty. Move on.
        [ -z $line ] && continue

            # ------- Layout Parsing ------
        if [[ ${line} = "--"* ]]; then
            cmd="--"
            args=""
        else
            local pattern="^\(-[[:alnum:]]*\)[[:blank:]]*\(.*\)"
            local cmd=$(echo "$line"  | sed -e "s/${pattern}/\1/")
            local args=$(echo "$line" | sed -e "s/${pattern}/\2/")
        fi

        case $cmd in
            "--")
                tmux split-window -h
                tmux select-layout "tiled"
                _do_tmux_send_activate_cmd
                ;;

            # "--" | "-split" | "-vsplit")
            #     tmux split-window -h
            #     tmux select-layout "tiled"
            #     _do_tmux_send_activate_cmd

            #     ;;

            # "-hsplit")
            #     tmux split-window -v
            #     tmux select-layout "tiled"
            #     _do_tmux_send_activate_cmd

            #     ;;

            "-sleep")
                sleep $args
                ;;

            *)
                # Sends the original line to tmux panel.
                _do_tmux_send_keys "$line"
                ;;
        esac
    done

    # Loads up the session
    tmux attach-session
}


# This util will kill the tmux session for a repository.
function _do_tmux_repo_stop() {
    local proj_dir=$1
    local repo=$2

    if ! _do_tmux_repo_enabled "${proj_dir}" "${repo}"; then 
        return
    fi

    _do_print_header_1 "Stops tmux for $repo"

    tmux kill-session -t "$repo" &> /dev/null

    return 0
}


# This util function send any commands to the top tmux session / windows
function _do_tmux_set_option() {
    tmux set-option $@
}


# This util function send any commands to the top tmux session / windows
function _do_tmux_send_keys() {
    tmux send-keys "$@" "C-m"
}


# This util function send devops activate commands to the top
# tmux session/windows
#
function _do_tmux_send_activate_cmd() {
    _do_tmux_send_keys "clear && bash"
    _do_tmux_send_keys "cd $DO_HOME && source activate.sh --quick $ENVIRONMENT"
}


# If the specified repository has a file ".tmux", tmux is enabled for 
# the repository. 
#
function _do_tmux_repo_enabled() {
    local proj_dir=$1
    local repo=$2

    if [ -f "${proj_dir}/${repo}/.tmux" ]; then 
        # Tmux integration is enabled for this repository.
        return 0
    else
        return 1
    fi
}


# ==============================================================================
# Plugin Init
# ==============================================================================

function _do_tmux_plugin_init() {
    _do_log_info "tmux" "Initialize plugin"
    _do_repo_cmd_hook_add "tmux" "init help"
}

