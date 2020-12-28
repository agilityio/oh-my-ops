
# Install drone database to local system. Internally, it will build a docker
# image that contains dronedb to run.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#
function _do_drone_repo_cmd_install() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  # The temporary directory that contains a copy of the src
  # docker directory.
  local tmp_dir
  tmp_dir=$(_do_dir_random_tmp_dir)

  # Makes the docker file
  # https://docs.drone.io/server/provider/gitlab/
  echo "
FROM drone/drone:${_DO_DRONE_VERSION}
ENV DRONE_SERVER_HOST=\"${_DO_DRONE_SERVER_HOST}\"
ENV DRONE_SERVER_PROTO=\"${_DO_DRONE_SERVER_PROTO}\"
ENV DRONE_RPC_SECRET=\"${_DO_DRONE_RPC_SECRET}\"
ENV DRONE_GIT_ALWAYS_AUTH=false

ENV DRONE_GITLAB_SERVER=\"${_DO_DRONE_GITLAB_SERVER}\"
ENV DRONE_GITLAB_CLIENT_ID=\"${_DO_DRONE_GITLAB_CLIENT_ID}\"
ENV DRONE_GITLAB_CLIENT_SECRET=\"${_DO_DRONE_GITLAB_CLIENT_SECRET}\"

ENV DRONE_USER_FILTER=\"${_DO_DRONE_USER}\"
ENV DRONE_USER_CREATE=\"username:${_DO_DRONE_USER},machine:false,admin:true\"
ENV DRONE_GITLAB_SKIP_VERIFY=true

" > "${tmp_dir}/Dockerfile"


  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_drone_docker_image_name "${repo}")

  # Builds the docker image. This might take a while.
  _do_docker_container_build "${tmp_dir}" "${image}" || {
    _do_dir_pop
    return 1
  }
}

# Starts drone server.
#
function _do_drone_repo_cmd_start() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  shift 3



  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_drone_docker_image_name "${repo}")

  # The name of the drone container, running for this repository only.
  local container
  container=$(_do_drone_docker_container_name "${repo}")

  ! _do_docker_container_exists "${container}" || {
    _do_print_error "The container is already running"
    return 1
  }

  local gitlab_container
  gitlab_container=$(_do_gitlab_docker_container_name "${repo}")

  _do_docker_container_exists "${gitlab_container}" || {
    _do_print_error "Gitlab container ${gitlab_container}, for repo ${repo} is not yet running. Please run it first."
    return 1
  }

  # shellcheck disable=SC2068
  {
    {
      # Makes sure the docker image is built
      _do_docker_image_exists "${image}" ||
      _do_drone_repo_cmd_install "${dir}" "${repo}" "${cmd}"
    } && {
      _do_log_info 'drone' 'Install default oauth application' &&
      _do_gitlab_repo_cmd_wait "${dir}" "${repo}" &&
      _do_gitlab_util_psql_create_application "${repo}" \
        "Drone" \
        "${_DO_DRONE_GITLAB_CLIENT_ID}" \
        "${_DO_DRONE_GITLAB_CLIENT_SECRET}" \
        "${_DO_DRONE_SERVER_PROTO}://${_DO_DRONE_SERVER_HOST}/login" \
        'api read_user openid'
    } &&

    # Runs the drone server as deamon
    _do_docker_container_run_deamon "${image}" "${container}" \
    --publish "${_DO_DRONE_HTTP_PORT}:80" \
    --publish "${_DO_DRONE_HTTPS_PORT}:443" \
    $@ &&

    # Notifies run success
    echo "Gitlab is running as '${container}' docker container." &&

    # Prints out some status about the server
    _do_drone_repo_cmd_status "${dir}" "${repo}"

  } || return 1
}


# Stops drone db server.
#
function _do_drone_repo_cmd_stop() {
  local repo=${2?'repo arg required'}

  # The name of the drone container, running for this repository only.
  local container
  container=$(_do_drone_docker_container_name "${repo}")

  _do_docker_container_exists "${container}" || {
    _do_print_warn "The container is not running"
    return 0
  }

  _do_docker_container_kill "${container}" &> /dev/null || return 1
}


# Attach
#
function _do_drone_repo_cmd_attach() {
  local repo=${2?'repo arg required'}

  # The name of the drone container, running for this repository only.
  local container
  container=$(_do_drone_docker_container_name "${repo}")

  _do_docker_container_attach "${container}" || return 1
}

# View logs
#
function _do_drone_repo_cmd_logs() {
  local repo=${2?'repo arg required'}

  # The name of the drone container, running for this repository only.
  local container
  container=$(_do_drone_docker_container_name "${repo}")

  _do_docker_container_logs "${container}" || return 1
}



# Stops drone db server.
#
function _do_drone_repo_cmd_status() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}

  local container
  container=$(_do_drone_docker_container_name "${repo}")

  local status
  if _do_docker_container_exists "${container}"; then
    status="Running"
  else
    status="Stopped"
  fi

  echo "
Status: ${status}
App: ${_DO_DRONE_SERVER_PROTO}://${_DO_DRONE_SERVER_HOST}
Environment variables:
  docker image: $(_do_drone_docker_image_name "${repo}")
  docker container: $(_do_drone_docker_container_name "${repo}")

  _DO_DRONE_VERSION: ${_DO_DRONE_VERSION}

  _DO_DRONE_RPC_SECRET=${_DO_DRONE_RPC_SECRET}
  _DO_DRONE_SERVER_HOST=${_DO_DRONE_SERVER_HOST}
  _DO_DRONE_SERVER_PROTO=${_DO_DRONE_SERVER_PROTO}

  _DO_DRONE_USER: ${_DO_DRONE_USER}
  _DO_DRONE_PASS: ${_DO_DRONE_PASS}
  _DO_DRONE_HTTP_PORT: ${_DO_DRONE_HTTP_PORT}
  _DO_DRONE_HTTPS_PORT: ${_DO_DRONE_HTTPS_PORT}

  _DO_DRONE_GITLAB_SERVER: ${_DO_DRONE_GITLAB_SERVER}
  _DO_DRONE_GITLAB_CLIENT_ID: ${_DO_DRONE_GITLAB_CLIENT_ID}
  _DO_DRONE_GITLAB_CLIENT_SECRET: ${_DO_DRONE_GITLAB_CLIENT_SECRET}
  "
}
