_do_assert_cmd "python"  

_do_plugin "docker"

_do_log_level_debug "python"

_do_src_include_others_same_dir

# ==============================================================================
# Plugin Init
# ==============================================================================
DO_PYTHON_PORT=8000

# The list of commands availble, eg., do-python-help, do-python-build, ...
_DO_PYTHON_CMDS=( "help" "clean" "build" )

# The python docker image to be used for local deployment.
# This image is built from the Dockerfile.
_DO_PYTHON_DOCKER_IMG="do_python"

_DO_PYTHON_DOCKER_CONTAINER_NAME="do_python"


# Initializes python plugin.
#
function _do_python_plugin_init() {
    _do_log_info "python" "Initialize plugin"
    _do_plugin_cmd "python" _DO_PYTHON_CMDS

    _do_repo_cmd_hook_add "python" "init help"

    # Adds alias that runs at repository level
    local cmds=( "clean" "build" )
    for cmd in ${cmds[@]}; do 
        alias "do-proj-python-${cmd}"="_do_proj_default_exec_all_repo_cmds python-${cmd}"
    done

    # Listens to docker stop all command and stop python as well.
    _do_hook_after "_do_docker_stop_all" "_do_python_stop"
}


# Builds the docker image that will be used for local deployment.
#
function _do_python_build() {
    _do_print_header_2 "Builds Python docker image ${_DO_PYTHON_DOCKER_IMG}"

    local dir="$DO_HOME/plugin/python"

    _do_dir_push $dir
    docker build . -t ${_DO_PYTHON_DOCKER_IMG}
    _do_dir_pop
}


# Ensures the docker image is built.
#
function _do_python_build_ensured() {
    if ! _do_docker_image_exists ${_DO_PYTHON_DOCKER_IMG}; then 
        _do_python_build
    fi
}


# Prints out helps for python supports.
#
function _do_python_help() {
    _do_log_info "python" "help"
}


# Prints out helps for python supports.
#
function _do_python_clean() {
    if _do_python_is_running; then 
        _do_print_warn "Python is running. do-python-stop to stop the server first."
        return 1
    fi    

    local img=${_DO_PYTHON_DOCKER_IMG}
    local title="Clean Python docker image $img"
    _do_print_header_2 $title

    if _do_docker_image_exists $img; then 
        _do_docker_image_remove $img
        local err=$?
        _do_error_report $err $title 
        return $err 

    else  
        _do_print_warn "Already cleaned"
    fi
}


# Determines if python is already running or not.
function _do_python_is_running() {
    local proj_dir=$1
    local repo=$2

    if _do_docker_process_exists ${_DO_PYTHON_DOCKER_CONTAINER_NAME}; then 
        return 0
    else 
        return 1
    fi
}


function _do_python_warn_not_running() {
    if _do_python_is_running; then 
        return 1
    else
        _do_print_warn "Python not yet running. do-python-start top run the server first."
        return 0
    fi
}

