
# Install gitlab database to local system. Internally, it will build a docker
# image that contains gitlabdb to run.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#
function _do_gitlab_repo_cmd_install() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  # The temporary directory that contains a copy of the src
  # docker directory.
  local tmp_dir
  tmp_dir=$(_do_dir_random_tmp_dir)

  # Makes the docker file
  # https://copdips.com/2018/09/install-gitlab-ce-in-docker-on-ubuntu.html#install-gitlab-ce-in-docker
  # See: https://docs.gitlab.com/12.10/ee/administration/environment_variables.html
  echo "
FROM gitlab/gitlab-ce:${_DO_GITLAB_VERSION}
ENV GITLAB_HOST=\"http://localhost:${_DO_GITLAB_HTTP_PORT}\"
" > "${tmp_dir}/Dockerfile"


  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_gitlab_docker_image_name "${repo}")

  # Builds the docker image. This might take a while.
  _do_docker_container_build "${tmp_dir}" "${image}" || {
    _do_dir_pop
    return 1
  }
}

# Starts gitlab server.
#
function _do_gitlab_repo_cmd_start() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  shift 3

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_gitlab_docker_image_name "${repo}")

  # The name of the gitlab container, running for this repository only.
  local container
  container=$(_do_gitlab_docker_container_name "${repo}")

  ! _do_docker_container_exists "${container}" || {
    _do_print_error "The container is already running"
    return 1
  }

  # shellcheck disable=SC2068
  {
    {
      # Makes sure the docker image is built
      _do_docker_image_exists "${image}" ||
      _do_gitlab_repo_cmd_install "${dir}" "${repo}" "${cmd}"
    } &&

    # Runs the gitlab server as deamon
    _do_docker_container_run_deamon "${image}" "${container}" \
    --publish "${_DO_GITLAB_HTTP_PORT}:80" \
    --publish "${_DO_GITLAB_HTTPS_PORT}:443" \
    --publish "${_DO_GITLAB_SSH_PORT}:22" \
    $@ &&

    # Notifies run success
    echo "Gitlab is running as '${container}' docker container." &&

    # Prints out some status about the server
    _do_gitlab_repo_cmd_status "${dir}" "${repo}"

  } || return 1
}


# Stops gitlab db server.
#
function _do_gitlab_repo_cmd_stop() {
  local repo=${2?'repo arg required'}

  # The name of the gitlab container, running for this repository only.
  local container
  container=$(_do_gitlab_docker_container_name "${repo}")

  _do_docker_container_exists "${container}" || {
    _do_print_error "The container is not running"
    return 1
  }

  _do_docker_container_kill "${container}" &> /dev/null || return 1
}


# Attach
#
function _do_gitlab_repo_cmd_attach() {
  local repo=${2?'repo arg required'}

  # The name of the gitlab container, running for this repository only.
  local container
  container=$(_do_gitlab_docker_container_name "${repo}")

  _do_docker_container_attach "${container}" || return 1
}

# View logs
#
function _do_gitlab_repo_cmd_logs() {
  local repo=${2?'repo arg required'}

  # The name of the gitlab container, running for this repository only.
  local container
  container=$(_do_gitlab_docker_container_name "${repo}")

  _do_docker_container_logs "${container}" || return 1
}



# Stops gitlab db server.
#
function _do_gitlab_repo_cmd_status() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}

  local container
  container=$(_do_gitlab_docker_container_name "${repo}")

  local status
  if _do_docker_container_exists "${container}"; then
    status="Running"
  else
    status="Stopped"
  fi

  echo "
Status: ${status}
Environment variables:
  docker image: $(_do_gitlab_docker_image_name "${repo}")
  docker container: $(_do_gitlab_docker_container_name "${repo}")

  _DO_GITLAB_VERSION: ${_DO_GITLAB_VERSION}
  _DO_GITLAB_USER: ${_DO_GITLAB_USER}
  _DO_GITLAB_PASS: ${_DO_GITLAB_PASS}
  _DO_GITLAB_HTTP_PORT: ${_DO_GITLAB_HTTP_PORT}
  _DO_GITLAB_HTTPS_PORT: ${_DO_GITLAB_HTTPS_PORT}
  _DO_GITLAB_SSH_PORT: ${_DO_GITLAB_SSH_PORT}
  "
}
