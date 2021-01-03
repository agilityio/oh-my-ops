
# Install gitlab database to local system. Internally, it will build a docker
# image that contains gitlab to run.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#
function _do_gitlab_repo_cmd_install() {
  local repo=${2?'repo arg required'}
  shift 3


  # The temporary directory that contains a copy of the src
  # docker directory.
  local tmp_dir
  tmp_dir=$(_do_dir_random_tmp_dir) || return 1

  # Makes the docker file
  # https://copdips.com/2018/09/install-gitlab-ce-in-docker-on-ubuntu.html#install-gitlab-ce-in-docker
  # See: https://docs.gitlab.com/12.10/ee/administration/environment_variables.html
  echo "
FROM gitlab/gitlab-ce:${_DO_GITLAB_VERSION}
ENV GITLAB_HOST=\"http://0.0.0.0:${_DO_GITLAB_HTTP_PORT}\"
ENV GITLAB_ROOT_PASSWORD=\"${_DO_GITLAB_PASS}\"
" > "${tmp_dir}/Dockerfile"

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_gitlab_docker_image_name "${repo}")

  # Builds the docker image. This might take a while.
  _do_docker_util_build_image "${tmp_dir}" "${image}" || return 1
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

  local host_ip
  host_ip=$(_do_docker_host_ip) || return 1


  ! _do_docker_util_container_exists "${container}" || {
    _do_print_error "The container is already running"
    return 1
  }

  _do_docker_util_create_default_network_if_missing || {
    _do_log_error 'gitlab' 'cannot starts default network'
    return 1
  }

  # shellcheck disable=SC2068
  {
    {
      # Makes sure the docker image is built
      _do_docker_util_image_exists "${image}" ||
      _do_gitlab_repo_cmd_install "${dir}" "${repo}" "${cmd}"
    } &&

    # Runs the gitlab server as deamon
    _do_docker_util_run_container_as_deamon "${image}" "${container}" \
      --network "${_DO_DOCKER_NETWORK}" \
      --publish "${_DO_GITLAB_HTTP_PORT}:80" \
      --publish "${_DO_GITLAB_HTTPS_PORT}:443" \
      --publish "${_DO_GITLAB_SSH_PORT}:22" \
      $@ &&

    # Waits for the server to be up
    _do_gitlab_repo_cmd_wait "${dir}" "${repo}" &&

    # Updates gitlab settings, to allow local webhooks, such as drone integration.
    _do_gitlab_util_update_application_settings "${repo}" "{
    \"outbound_local_requests_allowlist_raw\": \"${host_ip}\nlocalhost\",
    \"custom_http_clone_url_root\": \"http://${host_ip}:${_DO_GITLAB_HTTP_PORT}\",
    \"allow_local_requests_from_web_hooks_and_services\": true,
    \"allow_local_requests_from_system_hooks\": true
    }
    " &&

    # Notifies run success
    echo "Gitlab is running as '${container}' docker container." &&

    # Prints out some status about the server
    _do_gitlab_repo_cmd_status "${dir}" "${repo}"

  } || return 1
}


# Starts gitlab server.
#
function _do_gitlab_repo_cmd_wait() {
  local repo=${2?'repo arg required'}

  printf "Wait for gitlab to be up"
  until _do_gitlab_util_authenticate "$repo" &> /dev/null; do
    printf "."

    # Sleep a bit before trying again
    sleep 15
  done
  printf "\n"
}

# Stops gitlab db server.
#
function _do_gitlab_repo_cmd_stop() {
  local repo=${2?'repo arg required'}

  # The name of the gitlab container, running for this repository only.
  local container
  container=$(_do_gitlab_docker_container_name "${repo}")

  _do_docker_util_container_exists "${container}" || {
    _do_print_warn "The container is not running"
    return 0
  }

  _do_docker_util_kill_container "${container}" &> /dev/null || return 1
}


# Attach
#
function _do_gitlab_repo_cmd_attach() {
  local repo=${2?'repo arg required'}

  # The name of the gitlab container, running for this repository only.
  local container
  container=$(_do_gitlab_docker_container_name "${repo}")

  _do_docker_util_attach_to_container "${container}" || return 1
}

# View logs
#
function _do_gitlab_repo_cmd_logs() {
  local repo=${2?'repo arg required'}

  # The name of the gitlab container, running for this repository only.
  local container
  container=$(_do_gitlab_docker_container_name "${repo}")

  _do_docker_util_show_container_logs "${container}" || return 1
}



# Stops gitlab db server.
#
function _do_gitlab_repo_cmd_status() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}

  local container
  container=$(_do_gitlab_docker_container_name "${repo}")

  local status
  if _do_docker_util_container_exists "${container}"; then
    status="Running"
  else
    status="Stopped"
  fi

  echo "
Status: ${status}
App: http://localhost:${_DO_GITLAB_HTTP_PORT}
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
