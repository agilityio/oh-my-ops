function _do_registry_repo_cmd_install() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  local tmp_dir
  tmp_dir=$(_do_dir_random_tmp_dir)

  echo "
FROM registry:${_DO_REGISTRY_VERSION}
" > "${tmp_dir}/Dockerfile"

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_registry_docker_image_name "${repo}")

  # Builds the docker image. This might take a while.
  _do_docker_container_build "${tmp_dir}" "${image}" || {
    _do_dir_pop
    return 1
  }
}

# Starts registry server.
#
function _do_registry_repo_cmd_start() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  shift 3

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_registry_docker_image_name "${repo}")

  # The name of the registry container, running for this repository only.
  local container
  container=$(_do_registry_docker_container_name "${repo}")

  ! _do_docker_container_exists "${container}" || {
    _do_print_error "The container is already running"
    return 1
  }

  # shellcheck disable=SC2068
  {
    {
      # Makes sure the docker image is built
      _do_docker_image_exists "${image}" ||
      _do_registry_repo_cmd_install "${dir}" "${repo}" "${cmd}"
    } &&

    # Runs the registry server as deamon
    # TODO: Send in username/pass?
    _do_docker_container_run_deamon "${image}" "${container}" \
    --publish "${_DO_REGISTRY_PORT}:5000" \
    $@ &&

    # Notifies run success
    echo "Artifactory Rest API is running at port ${_DO_REGISTRY_PORT} as '${container}' docker container." &&

    # Prints out some status about the server
    _do_registry_repo_cmd_status "${dir}" "${repo}"

  } || return 1
}


# Stops registry db server.
#
function _do_registry_repo_cmd_stop() {
  local repo=${2?'repo arg required'}

  # The name of the registry container, running for this repository only.
  local container
  container=$(_do_registry_docker_container_name "${repo}")

  _do_docker_container_exists "${container}" || {
    _do_print_error "The container is not running"
    return 1
  }

  _do_docker_container_kill "${container}" &> /dev/null || return 1
}


# Logs into the registry server
#
function _do_registry_repo_cmd_login() {
  local repo=${2?'repo arg required'}

  if [[ -z "${_DO_REGISTRY_USER}" ]] || [[ -z "${_DO_REGISTRY_PASS}" ]]; then
    _do_log_warn 'registry' 'Skips login because either user or pass is empty.'
    return
  fi

  docker login --username "${_DO_REGISTRY_USER}" --password "${_DO_REGISTRY_PASS}" || return 1
}

# Logs out the registry server
#
function _do_registry_repo_cmd_logout() {
  local repo=${2?'repo arg required'}

  if [[ -z "${_DO_REGISTRY_USER}" ]] || [[ -z "${_DO_REGISTRY_PASS}" ]]; then
    _do_log_warn 'registry' 'Skips logout because either user or pass is empty.'
    return
  fi

  docker logout "${_DO_REGISTRY_HOST}":"${_DO_REGISTRY_PORT}" || 1
}


# Attach
#
function _do_registry_repo_cmd_attach() {
  local repo=${2?'repo arg required'}

  # The name of the registry container, running for this repository only.
  local container
  container=$(_do_registry_docker_container_name "${repo}")

  _do_docker_container_attach "${container}" || return 1
}

# View logs
#
function _do_registry_repo_cmd_logs() {
  local repo=${2?'repo arg required'}

  # The name of the registry container, running for this repository only.
  local container
  container=$(_do_registry_docker_container_name "${repo}")

  _do_docker_container_logs "${container}" || return 1
}

# Stops registry db server.
#
function _do_registry_repo_cmd_status() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}

  local container
  container=$(_do_registry_docker_container_name "${repo}")

  local status
  if _do_docker_container_exists "${container}"; then
    status="Running"
  else
    status="Stopped"
  fi

  echo "
Status: ${status}
Environment variables:
  docker image: $(_do_registry_docker_image_name "${repo}")
  docker container: $(_do_registry_docker_container_name "${repo}")

  _DO_REGISTRY_VERSION: ${_DO_REGISTRY_VERSION}
  _DO_REGISTRY_HOST: ${_DO_REGISTRY_HOST}
  _DO_REGISTRY_PORT: ${_DO_REGISTRY_PORT}
  _DO_REGISTRY_USER: ${_DO_REGISTRY_USER}
  _DO_REGISTRY_PASS: ${_DO_REGISTRY_PASS}
  "
}
