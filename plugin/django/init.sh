_do_plugin "python"

_do_log_level_debug "django"

_do_src_include_others_same_dir

# ==============================================================================
# Plugin Init
# ==============================================================================
DO_DJANGO_PORT=8000

# The list of commands availble, eg., do-django-help, do-django-build, ...
_DO_DJANGO_CMDS=( "help" "clean" "build" )

# The django docker image to be used for local deployment.
# This image is built from the Dockerfile.
_DO_DJANGO_DOCKER_IMG="do_django"

_DO_DJANGO_DOCKER_CONTAINER_NAME="do_django"


# Initializes django plugin.
#
function _do_django_plugin_init() {
    _do_log_info "django" "Initialize plugin"

    _do_plugin_cmd "django" _DO_DJANGO_CMDS

    # Listens to init proj repo hook.
    _do_proj_plugin "django" 
    _do_repo_cmd_hook_add "django" "init help clean build"

    # Adds alias that runs at repository level
    local cmds=( "clean" "build" )
    for cmd in ${cmds[@]}; do 
        alias "do-proj-django-${cmd}"="_do_proj_default_exec_all_repo_cmds django-${cmd}"
    done

    # Listens to docker stop all command and stop django as well.
    _do_hook_after "_do_docker_stop_all" "_do_django_stop"
}


# Builds the docker image that will be used for local deployment.
#
function _do_django_build() {
    _do_print_header_2 "Builds Django docker image ${_DO_DJANGO_DOCKER_IMG}"

    local dir="$DO_HOME/plugin/django"

    _do_dir_push $dir
    docker build . -t ${_DO_DJANGO_DOCKER_IMG}
    _do_dir_pop
}


# Ensures the docker image is built.
#
function _do_django_build_ensured() {
    if ! _do_docker_image_exists ${_DO_DJANGO_DOCKER_IMG}; then 
        _do_django_build
    fi
}


# Prints out helps for django supports.
#
function _do_django_help() {
    _do_log_info "django" "help"
}


# Prints out helps for django supports.
#
function _do_django_clean() {
    if _do_django_is_running; then 
        _do_print_warn "Django is running. do-django-stop to stop the server first."
        return 1
    fi    

    local img=${_DO_DJANGO_DOCKER_IMG}
    local title="Clean Django docker image $img"
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


# Determines if django is already running or not.
function _do_django_is_running() {
    local proj_dir=$1
    local repo=$2

    if _do_docker_process_exists ${_DO_DJANGO_DOCKER_CONTAINER_NAME}; then 
        return 0
    else 
        return 1
    fi
}


function _do_django_warn_not_running() {
    if _do_django_is_running; then 
        return 1
    else
        _do_print_warn "Django not yet running. do-django-start top run the server first."
        return 0
    fi
}

