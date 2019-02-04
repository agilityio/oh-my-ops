_do_plugin "docker"

_do_log_level_debug "redis"

# ==============================================================================
# Plugin Init
# ==============================================================================

# The exposed docker port for redis server.
DO_REDIS_PORT=6379

_DO_REDIS_CMDS=( "help" "start" "stop" "logs" "attach" )

# The redis docker image to be used for local deployment.
_DO_REDIS_DOCKER_IMG="redis:3.2.11"

_DO_REDIS_DOCKER_CONTAINER_NAME="do_redis"



# Initializes redis plugin.
#
function _do_redis_init() {
    _do_log_info "redis" "Initialize plugin"
    _do_plugin_cmd "redis" _DO_REDIS_CMDS

    _do_hook_after "_do_docker_stop_all" "_do_redis_stop"
}


# Prints out helps for redis supports.
#
function _do_redis_help() {
    _do_log_info "redis" "help"
}


# Starts redis server as deamon.
#
function _do_redis_start() {
    local port=${DO_REDIS_PORT}

    _do_print_header_2 "Redis Start on port ${port}"

    # Runs redis as deamon and automatically remove the named
    # container after finish.
    docker run --rm -d \
        --name="${_DO_REDIS_DOCKER_CONTAINER_NAME}"\
        -p "${port}:${port}" \
        "$_DO_REDIS_DOCKER_IMG" &> /dev/null
}


# Stops redis server.
#
function _do_redis_stop() {
    _do_print_header_2 "Redis Stop"

    docker kill ${_DO_REDIS_DOCKER_CONTAINER_NAME} &> /dev/null
}


# Stops redis server.
#
function _do_redis_logs() {
    _do_print_header_2 "Redis Logs"

    docker logs ${_DO_REDIS_DOCKER_CONTAINER_NAME}
}


# Attach redis server.
#
function _do_redis_attach() {
    _do_print_header_2 "Redis Attach"

    docker attach ${_DO_REDIS_DOCKER_CONTAINER_NAME}
}
