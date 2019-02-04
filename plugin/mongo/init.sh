_do_plugin "docker"

_do_log_level_debug "mongo"

# ==============================================================================
# Plugin Init
# ==============================================================================

# The exposed docker port for mongo server.
DO_MONGO_PORT=27017

_DO_MONGO_CMDS=( "help" "start" "stop" "logs" "attach" )

# The mongo docker image to be used for local deployment.
# This image is built from the Dockerfile.
_DO_MONGO_DOCKER_IMG="do_mongo"

_DO_MONGO_DOCKER_CONTAINER_NAME="do_mongo"


# Initializes mongo plugin.
#
function _do_mongo_init() {
    _do_log_info "mongo" "Initialize plugin"
    _do_plugin_cmd "mongo" _DO_MONGO_CMDS
    _do_hook_after "_do_docker_stop_all" "_do_mongo_stop"
}


# Builds the docker image that will be used for local deployment.
#
function _do_mongo_docker_build() {
    local dir="$DO_HOME/plugin/mongo"
    docker build "${dir}" -t ${_DO_MONGO_DOCKER_IMG}
}


# Prints out helps for mongo supports.
#
function _do_mongo_help() {
    _do_log_info "mongo" "help"
}


# Starts mongo server as deamon.
#
function _do_mongo_start() {
    local port=${DO_MONGO_PORT}

    # Builds the docker image first.
    _do_mongo_docker_build

    _do_print_header_2 "Mongo Start on port ${port}"

    # Runs mongo as deamon and automatically remove the named
    # container after finish.
    docker run --rm -d \
        --name="${_DO_MONGO_DOCKER_CONTAINER_NAME}"\
        -p "${port}:${port}" \
        "$_DO_MONGO_DOCKER_IMG" &> /dev/null
}


# Stops mongo server.
#
function _do_mongo_stop() {
    _do_print_header_2 "Mongo Stop"

    docker kill ${_DO_MONGO_DOCKER_CONTAINER_NAME} &> /dev/null
}


# Stops mongo server.
#
function _do_mongo_logs() {
    _do_print_header_2 "Mongo Logs"

    docker logs ${_DO_MONGO_DOCKER_CONTAINER_NAME}
}


# Attach mongo server.
#
function _do_mongo_attach() {
    _do_print_header_2 "Mongo Attach"

    docker attach ${_DO_MONGO_DOCKER_CONTAINER_NAME}
}
