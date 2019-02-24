_do_assert_cmd "go" "dep" 

_do_plugin "docker"

_do_log_level_warn "go"

_do_src_include_others_same_dir

# ==============================================================================
# Plugin Init
# ==============================================================================
DO_GO_PORT=8000

# The list of commands availble, eg., do-go-help, do-go-build, ...
_DO_GO_CMDS=( "help" "clean" "build" )

# The go docker image to be used for local deployment.
# This image is built from the Dockerfile.
_DO_GO_DOCKER_IMG="do_go"

_DO_GO_DOCKER_CONTAINER_NAME="do_go"


# Initializes go plugin.
#
function _do_go_plugin_init() {
    _do_log_info "go" "Initialize plugin"
    _do_plugin_cmd "go" _DO_GO_CMDS

    # Listens to init proj repo hook.
    _do_proj_plugin "go"

    _do_repo_cmd_hook_add "go" "gen help clean build"

    # Adds alias that runs at repository level
    local cmds=( "clean" "build" )
    for cmd in ${cmds[@]}; do 
        alias "do-proj-go-${cmd}"="_do_proj_default_exec_all_repo_cmds go-${cmd}"
    done

    # Listens to docker stop all command and stop go as well.
    _do_hook_after "_do_docker_stop_all" "_do_go_stop"
}


# Builds the docker image that will be used for local deployment.
#
function _do_go_build() {
    _do_print_header_2 "Builds Go docker image ${_DO_GO_DOCKER_IMG}"

    local dir="$DO_HOME/plugin/go"

    _do_dir_push $dir
    docker build . -t ${_DO_GO_DOCKER_IMG}
    _do_dir_pop
}


# Ensures the docker image is built.
#
function _do_go_build_ensured() {
    if ! _do_docker_image_exists ${_DO_GO_DOCKER_IMG}; then 
        _do_go_build
    fi
}


# Prints out helps for go supports.
#
function _do_go_help() {
    _do_log_info "go" "help"
}


# Prints out helps for go supports.
#
function _do_go_clean() {
    if _do_go_is_running; then 
        _do_print_warn "Go is running. do-go-stop to stop the server first."
        return 1
    fi    

    local img=${_DO_GO_DOCKER_IMG}
    local title="Clean Go docker image $img"
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


# Determines if go is already running or not.
function _do_go_is_running() {
    local proj_dir=$1
    local repo=$2

    if _do_docker_process_exists ${_DO_GO_DOCKER_CONTAINER_NAME}; then 
        return 0
    else 
        return 1
    fi
}


function _do_go_warn_not_running() {
    if _do_go_is_running; then 
        return 1
    else
        _do_print_warn "Go not yet running. do-go-start top run the server first."
        return 0
    fi
}

