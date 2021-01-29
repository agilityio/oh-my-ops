
# Install neo4j database to local system. Internally, it will build a docker
# image that contains neo4jdb to run.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#
function _do_neo4j_repo_cmd_install() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  # The temporary directory that contains a copy of the src
  # docker directory.
  local tmp_dir
  tmp_dir=$(_do_dir_random_tmp_dir)

  # Makes the docker file
  echo "
FROM neo4j:${_DO_NEO4J_VERSION}

ENV NEO4J_AUTH=${_DO_NEO4J_USER}/${_DO_NEO4J_PASS}
# ${_DO_NEO4J_HTTP_PORT} for HTTP.
# ${_DO_NEO4J_HTTPS_PORT} for HTTPS.
# ${_DO_NEO4J_BOLT_PORT} for Bolt.
EXPOSE ${_DO_NEO4J_HTTP_PORT} ${_DO_NEO4J_HTTPS_PORT} ${_DO_NEO4J_BOLT_PORT}
" > "${tmp_dir}/Dockerfile"


  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_neo4j_docker_image_name "${repo}")

  # Builds the docker image. This might take a while.
  _do_docker_util_build_image "${tmp_dir}" "${image}" || return 1
}

# Starts neo4j server.
#
function _do_neo4j_repo_cmd_start() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  shift 3

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_neo4j_docker_image_name "${repo}")

  # The name of the neo4j container, running for this repository only.
  local container
  container=$(_do_neo4j_docker_container_name "${repo}")

  ! _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is already running"
    return 1
  }

  # shellcheck disable=SC2068
  {
    {
      # Makes sure the docker image is built
      _do_docker_util_image_exists "${image}" ||
      _do_neo4j_repo_cmd_install "${dir}" "${repo}" "${cmd}"
    } &&

    # Runs the neo4j server as deamon
    # TODO: Send in username/pass?
    _do_docker_util_run_container_as_deamon "${image}" "${container}" \
    --publish "${_DO_NEO4J_HTTP_PORT}:${_DO_NEO4J_HTTP_PORT}" \
    --publish "${_DO_NEO4J_HTTPS_PORT}:${_DO_NEO4J_HTTPS_PORT}" \
    --publish "${_DO_NEO4J_BOLT_PORT}:${_DO_NEO4J_BOLT_PORT}" \
    $@ &&

    # Notifies run success
    echo "Neo4j is running at port http:${_DO_NEO4J_HTTP_PORT}, https:${_DO_NEO4J_HTTPS_PORT}, and bolt: ${_DO_NEO4J_BOLT_PORT}  as '${container}' docker container." &&

    # Prints out some status about the server
    _do_neo4j_repo_cmd_status "${dir}" "${repo}"

  } || return 1
}


# Stops neo4j db server.
#
function _do_neo4j_repo_cmd_stop() {
  local repo=${2?'repo arg required'}

  # The name of the neo4j container, running for this repository only.
  local container
  container=$(_do_neo4j_docker_container_name "${repo}")

  _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is not running"
    return 1
  }

  _do_docker_util_kill_container "${container}" &> /dev/null || return 1
}


# Attach
#
function _do_neo4j_repo_cmd_attach() {
  local repo=${2?'repo arg required'}

  # The name of the neo4j container, running for this repository only.
  local container
  container=$(_do_neo4j_docker_container_name "${repo}")

  _do_docker_util_attach_to_container "${container}" || return 1
}

# View logs
#
function _do_neo4j_repo_cmd_logs() {
  local repo=${2?'repo arg required'}

  # The name of the neo4j container, running for this repository only.
  local container
  container=$(_do_neo4j_docker_container_name "${repo}")

  _do_docker_util_show_container_logs "${container}" || return 1
}



# Stops neo4j db server.
#
function _do_neo4j_repo_cmd_status() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}

  local container
  container=$(_do_neo4j_docker_container_name "${repo}")

  local status
  if _do_docker_util_container_exists "${container}"; then
    status="Running"
  else
    status="Stopped"
  fi

  echo "
Status: ${status}
Environment variables:
  docker image: $(_do_neo4j_docker_image_name "${repo}")
  docker container: $(_do_neo4j_docker_container_name "${repo}")

  _DO_NEO4J_VERSION: ${_DO_NEO4J_VERSION}
  _DO_NEO4J_USER: ${_DO_NEO4J_USER}
  _DO_NEO4J_PASS: ${_DO_NEO4J_PASS}
  _DO_NEO4J_HTTP_PORT: ${_DO_NEO4J_HTTP_PORT}
  _DO_NEO4J_HTTPS_PORT: ${_DO_NEO4J_HTTPS_PORT}
  _DO_NEO4J_BOLT_PORT: ${_DO_NEO4J_BOLT_PORT}
  "
}
