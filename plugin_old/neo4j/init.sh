_do_plugin "docker"

_do_log_level_warn "neo4j"

# ==============================================================================
# Plugin Init
# ==============================================================================

# The exposed docker port for neo4j server.
export DO_NEO4J_HTTP_PORT=7474
export DO_NEO4J_HTTPS_PORT=7473
export DO_NEO4J_BOLT_PORT=7687
export DO_NEO4J_USER=neo4j
export DO_NEO4J_PASS=pass

# The list of commands availble, eg., do-neo4j-help, do-neo4j-build, ...
_DO_NEO4J_CMDS=("help" "clean" "build" "start" "stop" "logs" "attach" "admin")

# The neo4j docker image to be used for local deployment.
# This image is built from the Dockerfile.
_DO_NEO4J_DOCKER_IMG="do_neo4j"

_DO_NEO4J_DOCKER_CONTAINER_NAME="do_neo4j"

_DO_NEO4J_ADMIN_URL="http://localhost:${DO_NEO4J_HTTP_PORT}/browser"

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
function _do_neo4j_build() {
  _do_print_header_2 "Builds Neo4j docker image ${_DO_NEO4J_DOCKER_IMG}"

  local dir="$DO_HOME/plugin/neo4j"

  _do_dir_push $dir
  docker build . -t ${_DO_NEO4J_DOCKER_IMG}
  _do_dir_pop
}

# Ensures the docker image is built.
#
function _do_neo4j_build_ensured() {
  if ! _do_docker_image_exists ${_DO_NEO4J_DOCKER_IMG}; then
    _do_neo4j_build
  fi
}

# Prints out helps for neo4j supports.
#
function _do_neo4j_help() {
  _do_log_info "neo4j" "help"

  _do_print_header_2 "Neo4j help"

  _do_print_line_1 "Environment variables"

  echo "
  DO_NEO4J_HTTP_PORT  : ${DO_NEO4J_HTTP_PORT}
  DO_NEO4J_HTTPS_PORT : ${DO_NEO4J_HTTPS_PORT}
  DO_NEO4J_BOLT_PORT  : ${DO_NEO4J_BOLT_PORT}
  DO_NEO4J_USER       : ${DO_NEO4J_USER}
  DO_NEO4J_PASS       : ${DO_NEO4J_PASS}
    "

  _do_print_line_1 "Admin Site"
  echo "
  URL  : ${_DO_NEO4J_ADMIN_URL}
    "

  _do_print_line_1 "global commands"

  echo "
  do-neo4j-help:
    Show this help.

  do-neo4j-start:
    Starts local neo4j server.

  do-neo4j-stop:
    Stops local neo4j server.

  do-neo4j-logs:
    Shows local neo4j logs.

  do-neo4j-attach:
    Attaches local neo4j server.

  do-neo4j-admin:
    Opens the neo4j admin dashboard.
"
}

# Prints out helps for neo4j supports.
#
function _do_neo4j_clean() {
  if _do_neo4j_is_running; then
    _do_print_warn "Neo4j is running. do-neo4j-stop to stop the server first."
    return 1
  fi

  local img=${_DO_NEO4J_DOCKER_IMG}
  local title="Clean Neo4j docker image $img"
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

# Determines if neo4j is already running or not.
function _do_neo4j_is_running() {
  if _do_docker_process_exists ${_DO_NEO4J_DOCKER_CONTAINER_NAME}; then
    return 0
  else
    return 1
  fi
}

# Starts neo4j server as deamon.
#
function _do_neo4j_start() {
  # Builds the docker image first.
  if ! _do_neo4j_build_ensured; then
    return 1
  fi

  local title="Starts Neo4j on http:${DO_NEO4J_HTTP_PORT}, https:${DO_NEO4J_HTTPS_PORT}, Botl: ${DO_NEO4J_BOLT_PORT}"
  _do_print_header_2 $title

  if _do_neo4j_is_running; then
    _do_print_warn "Already running."
    return
  fi

  # Runs neo4j as deamon and automatically remove the named
  # container after finish.
  docker run --rm -d \
    --name="${_DO_NEO4J_DOCKER_CONTAINER_NAME}" \
    -p "${DO_NEO4J_HTTP_PORT}:${DO_NEO4J_HTTP_PORT}" \
    -p "${DO_NEO4J_HTTPS_PORT}:${DO_NEO4J_HTTPS_PORT}" \
    -p "${DO_NEO4J_BOLT_PORT}:${DO_NEO4J_BOLT_PORT}" \
    "$_DO_NEO4J_DOCKER_IMG" &>/dev/null

  local err=$?
  _do_error_report $err $title
  return $err
}

# Stops neo4j server.
#
function _do_neo4j_stop() {
  _do_print_header_2 "Neo4j Stop"

  if _do_neo4j_is_running; then
    docker kill ${_DO_NEO4J_DOCKER_CONTAINER_NAME} &>/dev/null
    local err=$?
    _do_error_report $err "Stopped"
    return $err
  else
    _do_print_warn "Already stopped"
  fi
}

# Stops neo4j server.
#
function _do_neo4j_logs() {
  if _do_neo4j_warn_not_running; then
    return 1
  fi

  _do_print_header_2 "Neo4j Logs"

  docker logs ${_DO_NEO4J_DOCKER_CONTAINER_NAME}
}

# Attach neo4j server.
#
function _do_neo4j_attach() {
  if _do_neo4j_warn_not_running; then
    return 1
  fi

  _do_print_header_2 "Neo4j Attach"

  docker attach ${_DO_NEO4J_DOCKER_CONTAINER_NAME}
}

function _do_neo4j_warn_not_running() {
  if _do_neo4j_is_running; then
    return 1
  else
    _do_print_warn "Neo4j not yet running. do-neo4j-start top run the server first."
    return 0
  fi
}

# Opens the dashboard web browser
#
function _do_neo4j_admin() {
  _do_log_info "neo4j" "admin"

  if _do_neo4j_warn_not_running; then
    return 1
  fi

  _do_print_header_2 "Neo4j Admin Dashboard"

  _do_browser_open "${_DO_NEO4J_ADMIN_URL}"
}
