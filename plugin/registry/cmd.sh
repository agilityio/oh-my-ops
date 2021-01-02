function _do_registry_repo_cmd_install() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  local tmp_dir
  tmp_dir=$(_do_dir_random_tmp_dir)


  # If user is not null, generates htpasswd for the registry server.
  # It is important to note that, registry server requires https to work.
  [[ -z "${_DO_REGISTRY_USER}" ]] ||
  _do_htpasswd_util_run "${_DO_REGISTRY_USER}" "${_DO_REGISTRY_PASS}" \
    >"${tmp_dir}/htpasswd" || {
    _do_log_error 'registry' 'Failed to generate htpasswd.'
    return 1
  }

  # See: https://gabrieltanner.org/blog/docker-registry
  echo "
FROM registry:${_DO_REGISTRY_VERSION}
ADD htpasswd /auth/htpasswd

ENV REGISTRY_AUTH=\"htpasswd\"
ENV REGISTRY_AUTH_HTPASSWD_REALM=\"Registry Realm\"
ENV REGISTRY_AUTH_HTPASSWD_PATH=\"/auth/htpasswd\"
" >"${tmp_dir}/Dockerfile"

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_registry_docker_image_name "${repo}")

  # Builds the docker image. This might take a while.
  _do_docker_util_build_image "${tmp_dir}" "${image}" || {
    _do_log_error 'registry' 'Failed to build docker image.'
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

  ! _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is already running"
    return 1
  }

  # shellcheck disable=SC2068
  {
    {
      # Makes sure the docker image is built
      _do_docker_util_image_exists "${image}" ||
        _do_registry_repo_cmd_install "${dir}" "${repo}" "${cmd}"
    } &&

      # Runs the registry server as deamon
      # TODO: Send in username/pass?
      _do_docker_util_run_container_as_deamon "${image}" "${container}" \
        --publish "${_DO_REGISTRY_PORT}:5000" \
        $@ &&

      # Notifies run success
      echo "Docker private registry server is running at port ${_DO_REGISTRY_PORT} as '${container}' docker container." &&

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

  _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is not running"
    return 1
  }

  _do_docker_util_kill_container "${container}" &>/dev/null || return 1
}

# Logs into the registry server
#
function _do_registry_repo_cmd_login() {
  local repo=${2?'repo arg required'}

  if [[ -z "${_DO_REGISTRY_USER}" ]] || [[ -z "${_DO_REGISTRY_PASS}" ]]; then
    _do_log_warn 'registry' 'Skips login because either user or pass is empty.'
    return
  fi

  echo "${_DO_REGISTRY_PASS}" | docker login --username "${_DO_REGISTRY_USER}" \
    --password-stdin \
    "${_DO_DOCKER_REGISTRY}" || return 1

  _do_print_blue "Successfully login into docker registry at: ${_DO_DOCKER_REGISTRY}."
}

# Logs out the registry server
#
function _do_registry_repo_cmd_logout() {
  local repo=${2?'repo arg required'}

  if [[ -z "${_DO_REGISTRY_USER}" ]] || [[ -z "${_DO_REGISTRY_PASS}" ]]; then
    _do_log_warn 'registry' 'Skips logout because either user or pass is empty.'
    return
  fi

  docker logout "${_DO_DOCKER_REGISTRY}" || 1
}

# Attach
#
function _do_registry_repo_cmd_attach() {
  local repo=${2?'repo arg required'}

  # The name of the registry container, running for this repository only.
  local container
  container=$(_do_registry_docker_container_name "${repo}")

  _do_docker_util_attach_to_container "${container}" || return 1
}

# View logs
#
function _do_registry_repo_cmd_logs() {
  local repo=${2?'repo arg required'}

  # The name of the registry container, running for this repository only.
  local container
  container=$(_do_registry_docker_container_name "${repo}")

  _do_docker_util_show_container_logs "${container}" || return 1
}

# Stops registry db server.
#
function _do_registry_repo_cmd_status() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}

  local container
  container=$(_do_registry_docker_container_name "${repo}")

  local status
  if _do_docker_util_container_exists "${container}"; then
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
