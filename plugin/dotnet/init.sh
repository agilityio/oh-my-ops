_do_plugin "docker"

_do_log_level_warn "dotnet"

_do_src_include_others_same_dir

# ==============================================================================
# Plugin Init
# ==============================================================================
DO_DOTNET_PORT=8000

# The list of commands availble, eg., do-dotnet-help, do-dotnet-build, ...
_DO_DOTNET_CMDS=( "help" "clean" "build" )

# The dotnet docker image to be used for local deployment.
# This image is built from the Dockerfile.
_DO_DOTNET_DOCKER_IMG="do_dotnet"

_DO_DOTNET_DOCKER_CONTAINER_NAME="do_dotnet"


# Initializes dotnet plugin.
#
function _do_dotnet_plugin_init() {
    if ! _do_alias_feature_check "dotnet" "dotnet"; then 
        return 
    fi 

    _do_log_info "dotnet" "Initialize plugin"
    _do_plugin_cmd "dotnet" _DO_DOTNET_CMDS

    _do_repo_cmd_hook_add "dotnet" "init help clean build"

    # Adds alias that runs at repository level
    local cmds=( "clean" "build" )
    for cmd in ${cmds[@]}; do 
        alias "do-all-dotnet-${cmd}"="_do_proj_default_exec_all_repo_cmds dotnet-${cmd}"
    done

    # Listens to docker stop all command and stop dotnet as well.
    _do_hook_after "_do_docker_stop_all" "_do_dotnet_stop"
}


# Builds the docker image that will be used for local deployment.
#
function _do_dotnet_build() {
    _do_print_header_2 "Builds Dotnet docker image ${_DO_DOTNET_DOCKER_IMG}"

    local dir="$DO_HOME/plugin/dotnet"

    _do_dir_push $dir
    docker build . -t ${_DO_DOTNET_DOCKER_IMG}
    _do_dir_pop
}


# Ensures the docker image is built.
#
function _do_dotnet_build_ensured() {
    if ! _do_docker_image_exists ${_DO_DOTNET_DOCKER_IMG}; then 
        _do_dotnet_build
    fi
}


# Prints out helps for dotnet supports.
#
function _do_dotnet_help() {
    _do_log_info "dotnet" "help"
}


# Prints out helps for dotnet supports.
#
function _do_dotnet_clean() {
    if _do_dotnet_is_running; then 
        _do_print_warn "Dotnet is running. do-dotnet-stop to stop the server first."
        return 1
    fi    

    local img=${_DO_DOTNET_DOCKER_IMG}
    local title="Clean Dotnet docker image $img"
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


# Determines if dotnet is already running or not.
function _do_dotnet_is_running() {
    local proj_dir=$1
    local repo=$2

    if _do_docker_process_exists ${_DO_DOTNET_DOCKER_CONTAINER_NAME}; then 
        return 0
    else 
        return 1
    fi
}


function _do_dotnet_warn_not_running() {
    if _do_dotnet_is_running; then 
        return 1
    else
        _do_print_warn "Dotnet not yet running. do-dotnet-start top run the server first."
        return 0
    fi
}

