# Install gitlabrunner database to local system. Internally, it will build a docker
# image that contains gitlabrunnerdb to run.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#
function _do_gitlabrunner_repo_cmd_install() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_gitlabrunner_docker_image_name "${repo}")

  # The temporary directory that contains a copy of the src
  # docker directory.
  local tmp_dir
  tmp_dir=$(_do_dir_random_tmp_dir)

  # Makes the docker file
  # https://awswithatiq.com/install-gitlabrunner-using-docker/
  echo "
FROM gitlab/gitlab-runner:${_DO_GITLABRUNNER_VERSION}
" >"${tmp_dir}/Dockerfile"

  # Builds the docker image. This might take a while.
  _do_docker_util_build_image "${tmp_dir}" "${image}" || return 1
}

# Starts gitlabrunner server.
#
function _do_gitlabrunner_repo_cmd_start() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  shift 3

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_gitlabrunner_docker_image_name "${repo}")

  # The name of the gitlabrunner container, running for this repository only.
  local container
  container=$(_do_gitlabrunner_docker_container_name "${repo}")

  ! _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is already running"
    return 1
  }

  # shellcheck disable=SC2068
  {
    {
      # Makes sure the docker image is built
      _do_docker_util_image_exists "${image}" ||
        _do_gitlabrunner_repo_cmd_install "${dir}" "${repo}" "${cmd}"
    } &&

      # Runs the gitlabrunner server as deamon
      _do_docker_util_run_container_as_deamon "${image}" "${container}" \
        -v /var/run/docker.sock:/var/run/docker.sock \
        --add-host "${_DO_DOCKER_HOST_NAME}:${_DO_DOCKER_HOST_IP}" \
        $@ &&

      # Just wait a bit for the server to init itself
      sleep 5 &&
      {
        local opts
        case "${_DO_GITLABRUNNER_EXECUTOR}" in
        docker)
          opts="--docker-image ${_DO_GITLABRUNNER_EXECUTOR_DOCKER_IMAGE} --docker-extra-hosts ${_DO_DOCKER_HOST_NAME}:${_DO_DOCKER_HOST_IP}"
          ;;
        *)
          opts=""
          ;;
        esac

        # Register the runner with the gitlab server
        # To figure out these command line arguments, you need to exec the
        # "gitlab-runner register --help" with the running container.
        # shellcheck disable=SC2090
        # shellcheck disable=SC2086
        docker exec "${container}" gitlab-runner register \
          --non-interactive \
          --url "http://${_DO_DOCKER_HOST_IP}:${_DO_GITLAB_HTTP_PORT}" \
          --registration-token "${_DO_GITLAB_RUNNER_TOKEN}" \
          --executor "${_DO_GITLABRUNNER_EXECUTOR}" \
          ${opts}
      } &&

      # Notifies run success
      echo "Gitlab Runner is running as '${container}' docker container." &&

      # Prints out some status about the server
      _do_gitlabrunner_repo_cmd_status "${dir}" "${repo}"

  } || return 1
}

# Stops gitlabrunner db server.
#
function _do_gitlabrunner_repo_cmd_stop() {
  local repo=${2?'repo arg required'}

  # The name of the gitlabrunner container, running for this repository only.
  local container
  container=$(_do_gitlabrunner_docker_container_name "${repo}")

  _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is not running"
    return 1
  }

  _do_docker_util_kill_container "${container}" &>/dev/null || return 1
}

# Attach
#
function _do_gitlabrunner_repo_cmd_attach() {
  local repo=${2?'repo arg required'}

  # The name of the gitlabrunner container, running for this repository only.
  local container
  container=$(_do_gitlabrunner_docker_container_name "${repo}")

  _do_docker_util_attach_to_container "${container}" || return 1
}

# View logs
#
function _do_gitlabrunner_repo_cmd_logs() {
  local repo=${2?'repo arg required'}

  # The name of the gitlabrunner container, running for this repository only.
  local container
  container=$(_do_gitlabrunner_docker_container_name "${repo}")

  _do_docker_util_show_container_logs "${container}" || return 1
}

# Stops gitlabrunner db server.
#
function _do_gitlabrunner_repo_cmd_status() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}

  local container
  container=$(_do_gitlabrunner_docker_container_name "${repo}")

  local status
  if _do_docker_util_container_exists "${container}"; then
    status="Running"
  else
    status="Stopped"
  fi

  echo "
Status: ${status}
Environment variables:
  docker image: $(_do_gitlabrunner_docker_image_name "${repo}")
  docker container: $(_do_gitlabrunner_docker_container_name "${repo}")

  _DO_GITLABRUNNER_VERSION: ${_DO_GITLABRUNNER_VERSION}
  _DO_GITLABRUNNER_EXECUTOR: ${_DO_GITLABRUNNER_EXECUTOR}
  _DO_GITLABRUNNER_EXECUTOR_DOCKER_IMAGE: ${_DO_GITLABRUNNER_EXECUTOR_DOCKER_IMAGE}
  "
}
