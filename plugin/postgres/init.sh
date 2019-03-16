_do_plugin "docker"

_do_log_level_warn "postgres"

# ==============================================================================
# Plugin Init
# ==============================================================================

# The exposed docker port for postgres server.
DO_POSTGRES_PORT=5432
DO_POSTGRES_DB=db
DO_POSTGRES_USER=user
DO_POSTGRES_PASS=pass

_DO_POSTGRES_CMDS=( "help" "start" "stop" "logs" "attach" )

# The postgres docker image to be used for local deployment.
# This image is built from the Dockerfile.
_DO_POSTGRES_DOCKER_IMG="do_postgres"

_DO_POSTGRES_DOCKER_CONTAINER_NAME="do_postgres"


# Initializes postgres plugin.
#
function _do_postgres_plugin_init() {
    _do_log_info "postgres" "Initialize plugin"
    _do_plugin_cmd "postgres" _DO_POSTGRES_CMDS

    # Listens to docker stop all command and stop postgres as well.
    _do_hook_after "_do_docker_stop_all" "_do_postgres_stop"
}


# Builds the docker image that will be used for local deployment.
#
function _do_postgres_docker_build() {
    local dir="$DO_HOME/plugin/postgres"
    _do_dir_push $dir
    docker build . -t ${_DO_POSTGRES_DOCKER_IMG}
    _do_dir_pop
}


# Prints out helps for postgres supports.
#
function _do_postgres_help() {
    _do_log_info "postgres" "help"

    _do_print_header_2 "Postgres help"

    _do_print_line_1 "Environment variables"

    echo "
  DO_POSTGRES_PORT : ${DO_POSTGRES_PORT} 
  DO_POSTGRES_DB   : ${DO_POSTGRES_DB} 
  DO_POSTGRES_USER : ${DO_POSTGRES_USER} 
  DO_POSTGRES_PASS : ${DO_POSTGRES_PASS} 
    "

    _do_print_line_1 "global commands"

    echo "  
  do-postgres-help:
    Show this help.

  do-postgres-start:
    Starts local postgres server.

  do-postgres-stop:
    Stops local postgres server.

  do-postgres-logs:
    Shows local postgres logs.

  do-postgres-attach:
    Attaches local postgres server.
"
}


# Starts postgres server as deamon.
#
function _do_postgres_start() {
    local port=${DO_POSTGRES_PORT}

    # Builds the docker image first.
    _do_postgres_docker_build

    _do_print_header_2 "Postgres Start on port ${port}"

    # Runs postgres as deamon and automatically remove the named
    # container after finish.
    docker run --rm -d \
        --name="${_DO_POSTGRES_DOCKER_CONTAINER_NAME}"\
        -p "${port}:${port}" \
        "$_DO_POSTGRES_DOCKER_IMG" &> /dev/null
}


# Stops postgres server.
#
function _do_postgres_stop() {
    _do_print_header_2 "Postgres Stop"

    docker kill ${_DO_POSTGRES_DOCKER_CONTAINER_NAME} &> /dev/null
}


# Stops postgres server.
#
function _do_postgres_logs() {
    _do_print_header_2 "Postgres Logs"

    docker logs ${_DO_POSTGRES_DOCKER_CONTAINER_NAME}
}


# Attach postgres server.
#
function _do_postgres_attach() {
    _do_print_header_2 "Postgres Attach"

    docker attach ${_DO_POSTGRES_DOCKER_CONTAINER_NAME}
}
