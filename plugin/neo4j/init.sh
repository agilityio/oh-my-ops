_do_plugin "docker"

_do_log_level_debug "neo4j"

# ==============================================================================
# Plugin Init
# ==============================================================================

# The exposed docker port for neo4j server.
DO_NEO4J_HTTP_PORT=7474
DO_NEO4J_HTTPS_PORT=7473
DO_NEO4J_BOLT_PORT=7687

_DO_NEO4J_CMDS=( "help" "start" "stop" "logs" "attach" )

# The neo4j docker image to be used for local deployment.
# This image is built from the Dockerfile.
_DO_NEO4J_DOCKER_IMG="do_neo4j"

_DO_NEO4J_DOCKER_CONTAINER_NAME="do_neo4j"


# Initializes neo4j plugin.
#
function _do_neo4j_plugin_init() {
    _do_log_info "neo4j" "Initialize plugin"
    _do_plugin_cmd "neo4j" _DO_NEO4J_CMDS

    # Listens to docker stop all command and stop neo4j as well.
    _do_hook_after "_do_docker_stop_all" "_do_neo4j_stop"
}


# Builds the docker image that will be used for local deployment.
#
function _do_neo4j_docker_build() {
    local dir="$DO_HOME/plugin/neo4j"
    _do_dir_push $dir
    docker build . -t ${_DO_NEO4J_DOCKER_IMG}
    _do_dir_pop
}


# Prints out helps for neo4j supports.
#
function _do_neo4j_help() {
    _do_log_info "neo4j" "help"
}


# Starts neo4j server as deamon.
#
function _do_neo4j_start() {
    # Builds the docker image first.
    _do_neo4j_docker_build

    _do_print_header_2 "Neo4j Start on http:${DO_NEO4J_HTTP_PORT}, https:${DO_NEO4J_HTTPS_PORT}, Botl: ${DO_NEO4J_BOLT_PORT}"

    # Runs neo4j as deamon and automatically remove the named
    # container after finish.
    docker run --rm -d \
        --name="${_DO_NEO4J_DOCKER_CONTAINER_NAME}"\
        -p "${DO_NEO4J_HTTP_PORT}:${DO_NEO4J_HTTP_PORT}" \
        -p "${DO_NEO4J_HTTPS_PORT}:${DO_NEO4J_HTTPS_PORT}" \
        -p "${DO_NEO4J_BOLT_PORT}:${DO_NEO4J_BOLT_PORT}" \
        "$_DO_NEO4J_DOCKER_IMG" &> /dev/null
}


# Stops neo4j server.
#
function _do_neo4j_stop() {
    _do_print_header_2 "Neo4j Stop"

    docker kill ${_DO_NEO4J_DOCKER_CONTAINER_NAME} &> /dev/null
}


# Stops neo4j server.
#
function _do_neo4j_logs() {
    _do_print_header_2 "Neo4j Logs"

    docker logs ${_DO_NEO4J_DOCKER_CONTAINER_NAME}
}


# Attach neo4j server.
#
function _do_neo4j_attach() {
    _do_print_header_2 "Neo4j Attach"

    docker attach ${_DO_NEO4J_DOCKER_CONTAINER_NAME}
}
