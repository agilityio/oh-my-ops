
# Install artifactory database to local system. Internally, it will build a docker
# image that contains artifactorydb to run.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#
function _do_artifactory_repo_cmd_install() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  # The temporary directory that contains a copy of the src
  # docker directory.
  local tmp_dir
  tmp_dir=$(_do_dir_random_tmp_dir)

  # Makes the docker file
  # See: https://bintray.com/beta/#/jfrog/reg2/jfrog:artifactory-oss/latest
  echo "
FROM docker.bintray.io/jfrog/artifactory-oss:${_DO_ARTIFACTORY_VERSION}
EXPOSE ${_DO_ARTIFACTORY_HTTP_REST_PORT} ${_DO_ARTIFACTORY_HTTP_UI_PORT}
" > "${tmp_dir}/Dockerfile"


  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_artifactory_docker_image_name "${repo}")

  # Builds the docker image. This might take a while.
  _do_docker_container_build "${tmp_dir}" "${image}" || {
    _do_dir_pop
    return 1
  }
}

# Starts artifactory server.
#
function _do_artifactory_repo_cmd_start() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  shift 3

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_artifactory_docker_image_name "${repo}")

  # The name of the artifactory container, running for this repository only.
  local container
  container=$(_do_artifactory_docker_container_name "${repo}")

  ! _do_docker_container_exists "${container}" || {
    _do_print_error "The container is already running"
    return 1
  }

  # shellcheck disable=SC2068
  {
    {
      # Makes sure the docker image is built
      _do_docker_image_exists "${image}" ||
      _do_artifactory_repo_cmd_install "${dir}" "${repo}" "${cmd}"
    } &&

    # Runs the artifactory server as deamon
    # TODO: Send in username/pass?
    _do_docker_container_run_deamon "${image}" "${container}" \
    --publish "${_DO_ARTIFACTORY_HTTP_REST_PORT}:8081" \
    --publish "${_DO_ARTIFACTORY_HTTP_UI_PORT}:8082" \
    $@ &&

    # Notifies run success
    echo "Artifactory Rest API is running at port ${_DO_ARTIFACTORY_HTTP_REST_PORT}, UI is at ${_DO_ARTIFACTORY_HTTP_UI_PORT}  as '${container}' docker container." &&

    # Prints out some status about the server
    _do_artifactory_repo_cmd_status "${dir}" "${repo}"

  } || return 1
}


# Stops artifactory db server.
#
function _do_artifactory_repo_cmd_stop() {
  local repo=${2?'repo arg required'}

  # The name of the artifactory container, running for this repository only.
  local container
  container=$(_do_artifactory_docker_container_name "${repo}")

  _do_docker_container_exists "${container}" || {
    _do_print_error "The container is not running"
    return 1
  }

  _do_docker_container_kill "${container}" &> /dev/null || return 1
}


# Attach
#
function _do_artifactory_repo_cmd_attach() {
  local repo=${2?'repo arg required'}

  # The name of the artifactory container, running for this repository only.
  local container
  container=$(_do_artifactory_docker_container_name "${repo}")

  _do_docker_container_attach "${container}" || return 1
}

# View logs
#
function _do_artifactory_repo_cmd_logs() {
  local repo=${2?'repo arg required'}

  # The name of the artifactory container, running for this repository only.
  local container
  container=$(_do_artifactory_docker_container_name "${repo}")

  _do_docker_container_logs "${container}" || return 1
}



# Stops artifactory db server.
#
function _do_artifactory_repo_cmd_status() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}

  local container
  container=$(_do_artifactory_docker_container_name "${repo}")

  local status
  if _do_docker_container_exists "${container}"; then
    status="Running"
  else
    status="Stopped"
  fi

  echo "
Status: ${status}
Environment variables:
  docker image: $(_do_artifactory_docker_image_name "${repo}")
  docker container: $(_do_artifactory_docker_container_name "${repo}")

  _DO_ARTIFACTORY_VERSION: ${_DO_ARTIFACTORY_VERSION}
  _DO_ARTIFACTORY_USER: ${_DO_ARTIFACTORY_USER}
  _DO_ARTIFACTORY_PASS: ${_DO_ARTIFACTORY_PASS}
  _DO_ARTIFACTORY_HTTP_REST_PORT: ${_DO_ARTIFACTORY_HTTP_REST_PORT}
  _DO_ARTIFACTORY_HTTP_UI_PORT: ${_DO_ARTIFACTORY_HTTP_UI_PORT}
  "
}
