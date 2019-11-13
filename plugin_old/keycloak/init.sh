_do_plugin "docker"
_do_plugin "postgres"

_do_log_level_warn "keycloak"

# ==============================================================================
# Plugin Init
# ==============================================================================

# The exposed docker port for keycloak server.
DO_KEYCLOAK_PORT=8080
DO_KEYCLOAK_ADMIN_USER=admin
DO_KEYCLOAK_ADMIN_PASS=admin

_DO_KEYCLOAK_CMDS=( "help" "start" "stop" "logs" "attach" )

# The keycloak docker image to be used for local deployment.
# This image is built from the Dockerfile.
_DO_KEYCLOAK_DOCKER_IMG="do_keycloak"

_DO_KEYCLOAK_DOCKER_CONTAINER_NAME="do_keycloak"


# Initializes keycloak plugin.
#
function _do_keycloak_plugin_init() {
    _do_log_info "keycloak" "Initialize plugin"
    _do_plugin_cmd "keycloak" _DO_KEYCLOAK_CMDS

    # Listens to docker stop all command and stop keycloak as well.
    _do_hook_after "_do_docker_stop_all" "_do_keycloak_stop"
}


# Builds the docker image that will be used for local deployment.
#
function _do_keycloak_docker_build() {
    local dir="$DO_HOME/plugin/keycloak"
    docker build "${dir}" -t ${_DO_KEYCLOAK_DOCKER_IMG}
}


# Prints out helps for keycloak supports.
#
function _do_keycloak_help() {
    _do_log_info "keycloak" "help"
}


# Starts keycloak server as deamon.
#
function _do_keycloak_start() {
    local port=${DO_KEYCLOAK_PORT}

    # Builds the docker image first.
    _do_keycloak_docker_build

    _do_print_header_2 "Keycloak Start on port ${port}"

    local host_ip=$(_do_docker_host_ip)

    # Runs keycloak as deamon and automatically remove the named
    # container after finish.
    docker run --rm -d \
        --name="${_DO_KEYCLOAK_DOCKER_CONTAINER_NAME}"\
        -p "${port}:${port}" \
        -e DB_VENDOR=POSTGRES \
        -e DB_ADDR=${host_ip} \
        -e DB_PORT=${DO_POSTGRES_PORT} \
        -e DB_DATABASE=db \
        -e DB_USER=user \
        -e DB_PASSWORD=pass \
        -e KEYCLOAK_USER=${DO_KEYCLOAK_ADMIN_USER} \
        -e KEYCLOAK_PASSWORD=${DO_KEYCLOAK_ADMIN_PASS} \
        "$_DO_KEYCLOAK_DOCKER_IMG" &> /dev/null
}


# Stops keycloak server.
#
function _do_keycloak_stop() {
    _do_print_header_2 "Keycloak Stop"

    docker kill ${_DO_KEYCLOAK_DOCKER_CONTAINER_NAME} &> /dev/null
}


# Stops keycloak server.
#
function _do_keycloak_logs() {
    _do_print_header_2 "Keycloak Logs"

    docker logs ${_DO_KEYCLOAK_DOCKER_CONTAINER_NAME}
}


# Attach keycloak server.
#
function _do_keycloak_attach() {
    _do_print_header_2 "Keycloak Attach"

    docker attach ${_DO_KEYCLOAK_DOCKER_CONTAINER_NAME}
}
