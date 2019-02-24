_do_plugin "docker"

_do_log_level_debug "sphinx"

_do_src_include_others_same_dir

# ==============================================================================
# Plugin Init
# ==============================================================================
DO_SPHINX_PORT=8000

# The list of commands availble, eg., do-sphinx-help, do-sphinx-build, ...
_DO_SPHINX_CMDS=( "help" "clean" "build" )

# The sphinx docker image to be used for local deployment.
# This image is built from the Dockerfile.
_DO_SPHINX_DOCKER_IMG="do_sphinx"

_DO_SPHINX_DOCKER_CONTAINER_NAME="do_sphinx"


# Initializes sphinx plugin.
#
function _do_sphinx_plugin_init() {
    _do_log_info "sphinx" "Initialize plugin"
    _do_plugin_cmd "sphinx" _DO_SPHINX_CMDS

    _do_repo_cmd_hook_add "sphinx" "init gen help clean build status"

    # Adds alias that runs at repository level
    local cmds=( "clean" "build" )
    for cmd in ${cmds[@]}; do 
        alias "do-proj-sphinx-${cmd}"="_do_proj_default_exec_all_repo_cmds sphinx-${cmd}"
    done

    # Listens to docker stop all command and stop sphinx as well.
    _do_hook_after "_do_docker_stop_all" "_do_sphinx_stop"
}


# Builds the docker image that will be used for local deployment.
#
function _do_sphinx_build() {
    _do_print_header_2 "Builds Sphinx docker image ${_DO_SPHINX_DOCKER_IMG}"

    local dir="$DO_HOME/plugin/sphinx/docker"

    _do_dir_push $dir
    docker build . -t ${_DO_SPHINX_DOCKER_IMG}
    _do_dir_pop
}


# Ensures the docker image is built.
#
function _do_sphinx_build_ensured() {
    if ! _do_docker_image_exists ${_DO_SPHINX_DOCKER_IMG}; then 
        _do_sphinx_build
    fi
}


# Prints out helps for sphinx supports.
#
function _do_sphinx_help() {
    _do_log_info "sphinx" "help"
}


# Prints out helps for sphinx supports.
#
function _do_sphinx_clean() {
    if _do_sphinx_is_running; then 
        _do_print_warn "Sphinx is running. do-sphinx-stop to stop the server first."
        return 1
    fi    

    local img=${_DO_SPHINX_DOCKER_IMG}
    local title="Clean Sphinx docker image $img"
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


# Determines if sphinx is already running or not.
function _do_sphinx_is_running() {
    local proj_dir=$1
    local repo=$2

    if _do_docker_process_exists ${_DO_SPHINX_DOCKER_CONTAINER_NAME}; then 
        return 0
    else 
        return 1
    fi
}


function _do_sphinx_warn_not_running() {
    if _do_sphinx_is_running; then 
        return 1
    else
        _do_print_warn "Sphinx not yet running. do-sphinx-start top run the server first."
        return 0
    fi
}

