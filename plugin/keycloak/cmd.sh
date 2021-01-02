
# Install keycloak database to local system. Internally, it will build a docker
# image that contains keycloakdb to run.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#
function _do_keycloak_repo_cmd_install() {
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
FROM jboss/keycloak:${_DO_KEYCLOAK_VERSION}

EXPOSE ${_DO_KEYCLOAK_PORT}
" > "${tmp_dir}/Dockerfile"


  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_keycloak_docker_image_name "${repo}")

  # Builds the docker image. This might take a while.
  _do_docker_util_build_image "${tmp_dir}" "${image}" || return 1
}

# Starts keycloak server.
#
function _do_keycloak_repo_cmd_start() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  shift 3

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_keycloak_docker_image_name "${repo}")

  # The name of the keycloak container, running for this repository only.
  local container
  container=$(_do_keycloak_docker_container_name "${repo}")

  ! _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is already running"
    return 1
  }

  # This is the local port that the server un on.
  local port
  port=${_DO_KEYCLOAK_PORT}

  # shellcheck disable=SC2068
  {
    {
      # Makes sure the docker image is built
      _do_docker_util_image_exists "${image}" ||
      _do_keycloak_repo_cmd_install "${dir}" "${repo}" "${cmd}"
    } &&

    # Runs the keycloak server as deamon
    _do_docker_util_run_container_as_deamon "${image}" "${container}" \
      -e DB_DATABASE="${_DO_KEYCLOAK_DB}" \
      -e DB_USER="${_DO_KEYCLOAK_USER}" \
      -e DB_PASSWORD="${_DO_KEYCLOAK_PASS}" \
      -e KEYCLOAK_USER="${_DO_KEYCLOAK_ADMIN_USER}" \
      -e KEYCLOAK_PASSWORD="${_DO_KEYCLOAK_ADMIN_PASS}" \
      -p "${port}:${_DO_KEYCLOAK_PORT}" \
      $@ &> /dev/null &&

    # Notifies run success
    echo "Keycloak is running at port ${port} as '${container}' docker container." &&

    # Prints out some status about the server
    _do_keycloak_repo_cmd_status "${dir}" "${repo}"

  } || return 1
}


# Stops keycloak db server.
#
function _do_keycloak_repo_cmd_stop() {
  local repo=${2?'repo arg required'}

  # The name of the keycloak container, running for this repository only.
  local container
  container=$(_do_keycloak_docker_container_name "${repo}")

  _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is not running"
    return 1
  }

  _do_docker_util_kill_container "${container}" &> /dev/null || return 1
}


# Attach
#
function _do_keycloak_repo_cmd_attach() {
  local repo=${2?'repo arg required'}

  # The name of the keycloak container, running for this repository only.
  local container
  container=$(_do_keycloak_docker_container_name "${repo}")

  _do_docker_util_attach_to_container "${container}" || return 1
}

# View logs
#
function _do_keycloak_repo_cmd_logs() {
  local repo=${2?'repo arg required'}

  # The name of the keycloak container, running for this repository only.
  local container
  container=$(_do_keycloak_docker_container_name "${repo}")

  _do_docker_util_show_container_logs "${container}" || return 1
}



# Stops keycloak db server.
#
function _do_keycloak_repo_cmd_status() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}

  local status
  if _do_docker_util_container_exists "${_DO_KEYCLOAK_DOCKER_IMAGE}"; then
    status="Running"
  else
    status="Stopped"
  fi

  echo "
Status: ${status}
Environment variables:
  docker image: $(_do_keycloak_docker_image_name "${repo}")
  docker container: $(_do_keycloak_docker_container_name "${repo}")

  _DO_KEYCLOAK_VERSION: ${_DO_KEYCLOAK_VERSION}
  _DO_KEYCLOAK_PORT: ${_DO_KEYCLOAK_PORT}
  _DO_KEYCLOAK_DB: ${_DO_KEYCLOAK_DB}
  _DO_KEYCLOAK_USER: ${_DO_KEYCLOAK_USER}
  _DO_KEYCLOAK_PASS: ${_DO_KEYCLOAK_PASS}
  _DO_KEYCLOAK_ADMIN_USER: ${_DO_KEYCLOAK_ADMIN_USER}
  _DO_KEYCLOAK_ADMIN_PASS: ${_DO_KEYCLOAK_ADMIN_PASS}
  "
}
