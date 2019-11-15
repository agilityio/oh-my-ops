_do_plugin "docker"

_do_log_level_warn "mongo"

# ==============================================================================
# Plugin Init
# ==============================================================================

# The exposed docker port for mongo server.
DO_MONGO_PORT=27017
DO_MONGO_DB=db
DO_MONGO_PASS=pass
DO_MONGO_USER=user
DO_MONGO_ADMIN_USER=admin
DO_MONGO_ADMIN_PASS=admin

_DO_MONGO_CMDS=( "help" "start" "stop" "logs" "attach" )

# The mongo docker image to be used for local deployment.
# This image is built from the Dockerfile.
_DO_MONGO_DOCKER_IMG="do_mongo"

_DO_MONGO_DOCKER_CONTAINER_NAME="do_mongo"


# Initializes mongo plugin.
#
function _do_mongo_plugin_init() {
    _do_log_info "mongo" "Initialize plugin"
    _do_plugin_cmd "mongo" _DO_MONGO_CMDS

    _do_hook_after "_do_docker_stop_all" "_do_mongo_stop"
}


# Builds the docker image that will be used for local deployment.
#
function _do_mongo_docker_build() {
    local dir="$DO_HOME/plugin/mongo"
    _do_dir_push $dir
    docker build . -t ${_DO_MONGO_DOCKER_IMG}
    _do_dir_pop
}


# Prints out helps for mongo supports.
#
function _do_mongo_help() {
    _do_log_info "mongo" "help"

    _do_print_header_2 "Mongo help"

    _do_print_line_1 "Environment variables"

    echo "
  DO_MONGO_PORT       : ${DO_MONGO_PORT} 
  DO_MONGO_DB         : ${DO_MONGO_DB} 
  DO_MONGO_USER       : ${DO_MONGO_USER} 
  DO_MONGO_PASS       : ${DO_MONGO_PASS} 
  DO_MONGO_ADMIN_USER : ${DO_MONGO_ADMIN_USER} 
  DO_MONGO_ADMIN_PASS : ${DO_MONGO_ADMIN_PASS} 
    "

    _do_print_line_1 "global commands"

    echo "  
  do-mongo-help:
    Show this help.

  do-mongo-start:
    Starts local mongo server.

  do-mongo-stop:
    Stops local mongo server.

  do-mongo-logs:
    Shows local mongo logs.

  do-mongo-attach:
    Attaches local mongo server.
"
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
