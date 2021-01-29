
# Install rabbitmq database to local system. Internally, it will build a docker
# image that contains rabbitmqdb to run.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#
function _do_rabbitmq_repo_cmd_install() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  # The temporary directory that contains a copy of the src
  # docker directory.
  local tmp_dir
  tmp_dir=$(_do_dir_random_tmp_dir)

  # Makes the docker file
  # https://awswithatiq.com/install-rabbitmq-using-docker/
  echo "
FROM rabbitmq:${_DO_RABBITMQ_VERSION}
ENV RABBITMQ_DEFAULT_USER=\"${_DO_RABBITMQ_USER}\"
ENV RABBITMQ_DEFAULT_PASS=\"${_DO_RABBITMQ_PASS}\"
" > "${tmp_dir}/Dockerfile"


  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_rabbitmq_docker_image_name "${repo}")

  # Builds the docker image. This might take a while.
  _do_docker_util_build_image "${tmp_dir}" "${image}" || return 1
}

# Starts rabbitmq server.
#
function _do_rabbitmq_repo_cmd_start() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  shift 3

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_rabbitmq_docker_image_name "${repo}")

  # The name of the rabbitmq container, running for this repository only.
  local container
  container=$(_do_rabbitmq_docker_container_name "${repo}")

  ! _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is already running"
    return 1
  }

  # shellcheck disable=SC2068
  {
    {
      # Makes sure the docker image is built
      _do_docker_util_image_exists "${image}" ||
      _do_rabbitmq_repo_cmd_install "${dir}" "${repo}" "${cmd}"
    } &&

    # Runs the rabbitmq server as deamon
    _do_docker_util_run_container_as_deamon "${image}" "${container}" \
    --publish "${_DO_RABBITMQ_HTTP_PORT}:15672" \
    $@ &&

    # Notifies run success
    echo "Rest API is running at port ${_DO_RABBITMQ_HTTP_PORT} as '${container}' docker container." &&

    # Prints out some status about the server
    _do_rabbitmq_repo_cmd_status "${dir}" "${repo}"

  } || return 1
}


# Stops rabbitmq db server.
#
function _do_rabbitmq_repo_cmd_stop() {
  local repo=${2?'repo arg required'}

  # The name of the rabbitmq container, running for this repository only.
  local container
  container=$(_do_rabbitmq_docker_container_name "${repo}")

  _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is not running"
    return 1
  }

  _do_docker_util_kill_container "${container}" &> /dev/null || return 1
}


# Attach
#
function _do_rabbitmq_repo_cmd_attach() {
  local repo=${2?'repo arg required'}

  # The name of the rabbitmq container, running for this repository only.
  local container
  container=$(_do_rabbitmq_docker_container_name "${repo}")

  _do_docker_util_attach_to_container "${container}" || return 1
}

# View logs
#
function _do_rabbitmq_repo_cmd_logs() {
  local repo=${2?'repo arg required'}

  # The name of the rabbitmq container, running for this repository only.
  local container
  container=$(_do_rabbitmq_docker_container_name "${repo}")

  _do_docker_util_show_container_logs "${container}" || return 1
}



# Stops rabbitmq db server.
#
function _do_rabbitmq_repo_cmd_status() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}

  local container
  container=$(_do_rabbitmq_docker_container_name "${repo}")

  local status
  if _do_docker_util_container_exists "${container}"; then
    status="Running"
  else
    status="Stopped"
  fi

  echo "
Status: ${status}
Environment variables:
  docker image: $(_do_rabbitmq_docker_image_name "${repo}")
  docker container: $(_do_rabbitmq_docker_container_name "${repo}")

  _DO_RABBITMQ_VERSION: ${_DO_RABBITMQ_VERSION}
  _DO_RABBITMQ_USER: ${_DO_RABBITMQ_USER}
  _DO_RABBITMQ_PASS: ${_DO_RABBITMQ_PASS}
  _DO_RABBITMQ_HTTP_PORT: ${_DO_RABBITMQ_HTTP_PORT}
  "
}
