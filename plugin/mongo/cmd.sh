# Install mongo database to local system. Internally, it will build a docker
# image that contains mongodb to run.
#
function _do_mongo_repo_cmd_install() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  local dir
  dir="$DO_HOME/plugin/mongo/docker"

  _do_docker_container_build "${dir}" "${_DO_MONGO_DOCKER_IMAGE}" || {
    _do_dir_pop
    return 1
  }
}

# Starts mongo server.
#
function _do_mongo_repo_cmd_start() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  {
    _do_mongo_repo_cmd_install "${dir}" "${repo}" "${cmd}" &&
      _do_docker_container_run_deamon "${_DO_MONGO_DOCKER_IMAGE}" "${_DO_MONGO_DOCKER_CONTAINER}"
  } || return 1
}

# Stops mongo db server.
#
function _do_mongo_repo_cmd_stop() {
  _do_docker_container_kill "${_DO_MONGO_DOCKER_IMAGE}" || return 1
}

# Stops mongo db server.
#
function _do_mongo_repo_cmd_status() {
  local status

  if _do_docker_container_exists "${_DO_MONGO_DOCKER_IMAGE}"; then
    status="Running"
  else
    status="Stopped"
  fi

  echo "
Status: ${status}
Environment variables:
  _DO_MONGO_DOCKER_IMAGE: ${_DO_MONGO_DOCKER_IMAGE}
  _DO_MONGO_DOCKER_CONTAINER: ${_DO_MONGO_DOCKER_CONTAINER}
  _DO_MONGO_PORT: ${_DO_MONGO_PORT}
  _DO_MONGO_ADMIN_USER: ${_DO_MONGO_ADMIN_USER}
  _DO_MONGO_ADMIN_PASS: ${_DO_MONGO_ADMIN_PASS}
  _DO_MONGO_DB: ${_DO_MONGO_DB}
  _DO_MONGO_USER: ${_DO_MONGO_USER}
  _DO_MONGO_PASS: ${_DO_MONGO_PASS}
  "
}
