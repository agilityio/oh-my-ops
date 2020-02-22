
# Install mongo database to local system. Internally, it will build a docker
# image that contains mongodb to run.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#
function _do_mongo_repo_cmd_install() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  # The directory that contains the docker file
  # to build the docker image to run mongo database server.
  local src_dir
  src_dir="$DO_HOME/plugin/mongo/docker"

  # The temporary directory that contains a copy of the src
  # docker directory.
  local tmp_dir
  tmp_dir=$(_do_dir_copy_to_random_tmp_dir "${src_dir}") || return 1

  # Makes the docker file
  echo "
FROM mongo:${_DO_MONGO_VERSION}

WORKDIR /app

ADD bin /app/bin

ENV MONGODB_NAME ${_DO_MONGO_DB}
ENV MONGODB_USER ${_DO_MONGO_USER}
ENV MONGODB_PASSWORD ${_DO_MONGO_PASS}
ENV MONGODB_ADMIN_USER ${_DO_MONGO_ADMIN_USER}
ENV MONGODB_ADMIN_PASS ${_DO_MONGO_ADMIN_PASS}

EXPOSE ${_DO_MONGO_PORT}

ENTRYPOINT [ \"/app/bin/entrypoint.sh\" ]
  " > "${tmp_dir}/docker/Dockerfile"


  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_mongo_docker_image_name "${repo}")

  # Builds the docker image. This might take a while.
  _do_docker_container_build "${tmp_dir}"/docker "${image}" || {
    _do_dir_pop
    return 1
  }
}

# Starts mongo server.
#
function _do_mongo_repo_cmd_start() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  shift 3

  # The docker image to build. This image name is localized
  # to the current repository only.
  local image
  image=$(_do_mongo_docker_image_name "${repo}")

  # The name of the mongo container, running for this repository only.
  local container
  container=$(_do_mongo_docker_container_name "${repo}")

  ! _do_docker_container_exists "${container}" || {
    _do_print_error "The container is already running"
    return 1
  }

  # This is the local port that the server un on.
  local port
  port=${_DO_MONGO_PORT}

  # shellcheck disable=SC2068
  {
    {
      # Makes sure the docker image is built
      _do_docker_image_exists "${image}" ||
      _do_mongo_repo_cmd_install "${dir}" "${repo}" "${cmd}"
    } &&
    _do_docker_container_run_deamon "${image}" "${container}" \
      -p "${port}:${_DO_MONGO_PORT}" $@

  } || return 1
}


# Stops mongo db server.
#
function _do_mongo_repo_cmd_stop() {
  local repo=${2?'repo arg required'}

  # The name of the mongo container, running for this repository only.
  local container
  container=$(_do_mongo_docker_container_name "${repo}")

  _do_docker_container_exists "${container}" || {
    _do_print_error "The container is not running"
    return 1
  }

  _do_docker_container_kill "${container}" || return 1
}


# Attach
#
function _do_mongo_repo_cmd_attach() {
  local repo=${2?'repo arg required'}

  # The name of the mongo container, running for this repository only.
  local container
  container=$(_do_mongo_docker_container_name "${repo}")

  _do_docker_container_attach "${container}" || return 1
}

# View logs
#
function _do_mongo_repo_cmd_logs() {
  local repo=${2?'repo arg required'}

  # The name of the mongo container, running for this repository only.
  local container
  container=$(_do_mongo_docker_container_name "${repo}")

  _do_docker_container_logs "${container}" || return 1
}



# Stops mongo db server.
#
function _do_mongo_repo_cmd_status() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}

  local status
  if _do_docker_container_exists "${_DO_MONGO_DOCKER_IMAGE}"; then
    status="Running"
  else
    status="Stopped"
  fi

  echo "
Status: ${status}
Environment variables:
  docker image: $(_do_mongo_docker_image_name "${repo}")
  docker container: $(_do_mongo_docker_container_name "${repo}")

  _DO_MONGO_PORT: ${_DO_MONGO_PORT}
  _DO_MONGO_ADMIN_USER: ${_DO_MONGO_ADMIN_USER}
  _DO_MONGO_ADMIN_PASS: ${_DO_MONGO_ADMIN_PASS}
  _DO_MONGO_DB: ${_DO_MONGO_DB}
  _DO_MONGO_USER: ${_DO_MONGO_USER}
  _DO_MONGO_PASS: ${_DO_MONGO_PASS}
  "
}
