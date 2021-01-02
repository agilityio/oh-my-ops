# Install pypiserver database to local system. Internally, it will build a docker
# image that contains pypiserver to run.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#
function _do_pypiserver_repo_cmd_install() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  # The temporary directory that contains a copy of the src
  # docker directory.
  local tmp_dir
  tmp_dir=$(_do_dir_random_tmp_dir)

  _do_htpasswd_util_run "${_DO_PYPISERVER_USER}" "${_DO_PYPISERVER_PASS}" >"${tmp_dir}/.htpasswd"

  # Makes the docker file
  # https://pypi.org/project/pypiserver/#using-the-docker-image
  echo "
FROM pypiserver/pypiserver:${_DO_PYPISERVER_VERSION}
ADD .htpasswd /data/.htpasswd

ENTRYPOINT /entrypoint.sh -P /data/.htpasswd
" >"${tmp_dir}/Dockerfile"

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_pypiserver_docker_image_name "${repo}")

  # Builds the docker image. This might take a while.
  _do_docker_util_build_image "${tmp_dir}" "${image}" || {
    _do_dir_pop
    return 1
  }
}

# Starts pypiserver server.
#
function _do_pypiserver_repo_cmd_start() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  shift 3

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_pypiserver_docker_image_name "${repo}")

  # The name of the pypiserver container, running for this repository only.
  local container
  container=$(_do_pypiserver_docker_container_name "${repo}")

  ! _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is already running"
    return 1
  }

  # shellcheck disable=SC2068
  {
    {
      # Makes sure the docker image is built
      _do_docker_util_image_exists "${image}" ||
        _do_pypiserver_repo_cmd_install "${dir}" "${repo}" "${cmd}"
    } &&

      # Runs the pypiserver server as deamon
      # TODO: Send in username/pass?
      _do_docker_util_run_container_as_deamon "${image}" "${container}" \
        --publish "${_DO_PYPISERVER_PORT}:8080" \
        $@ &&

      # Notifies run success
      echo "PyPiServer is at ${_DO_PYPISERVER_PORT} as '${container}' docker container." &&

      # Prints out some status about the server
      _do_pypiserver_repo_cmd_status "${dir}" "${repo}"

  } || return 1
}

# Stops pypiserver db server.
#
function _do_pypiserver_repo_cmd_stop() {
  local repo=${2?'repo arg required'}

  # The name of the pypiserver container, running for this repository only.
  local container
  container=$(_do_pypiserver_docker_container_name "${repo}")

  _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is not running"
    return 1
  }

  _do_docker_util_kill_container "${container}" &>/dev/null || return 1
}

# Attach
#
function _do_pypiserver_repo_cmd_attach() {
  local repo=${2?'repo arg required'}

  # The name of the pypiserver container, running for this repository only.
  local container
  container=$(_do_pypiserver_docker_container_name "${repo}")

  _do_docker_util_attach_to_container "${container}" || return 1
}

# View logs
#
function _do_pypiserver_repo_cmd_logs() {
  local repo=${2?'repo arg required'}

  # The name of the pypiserver container, running for this repository only.
  local container
  container=$(_do_pypiserver_docker_container_name "${repo}")

  _do_docker_util_show_container_logs "${container}" || return 1
}

# Stops pypiserver db server.
#
function _do_pypiserver_repo_cmd_status() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}

  local container
  container=$(_do_pypiserver_docker_container_name "${repo}")

  local status
  if _do_docker_util_container_exists "${container}"; then
    status="Running"
  else
    status="Stopped"
  fi

  echo "
Status: ${status}
App: http://localhost:${_DO_PYPISERVER_PORT}
Environment variables:
  docker image: $(_do_pypiserver_docker_image_name "${repo}")
  docker container: $(_do_pypiserver_docker_container_name "${repo}")

  _DO_PYPISERVER_VERSION: ${_DO_PYPISERVER_VERSION}
  _DO_PYPISERVER_USER: ${_DO_PYPISERVER_USER}
  _DO_PYPISERVER_PASS: ${_DO_PYPISERVER_PASS}
  _DO_PYPISERVER_PORT: ${_DO_PYPISERVER_PORT}
  "
}
