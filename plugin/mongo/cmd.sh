# Install mongo database to local system. Internally, it will build a docker
# image that contains mongodb to run.
#
function _do_mongo_install() {
  local dir
  dir="$DO_HOME/plugin/mongo"

  _do_docker_util_build "${dir}" "${_DO_MONGO_DOCKER_IMAGE}" || {
    _do_dir_pop
    return 1
  }
}

# Starts mongo server.
#
function _do_mongo_start() {
  {
    _do_mongo_install &&
    _do_docker_util_run_deamon "${_DO_MONGO_DOCKER_IMAGE}" "${_DO_MONGO_DOCKER_CONTAINER}"
  } || return 1
}


# Stops mongo db server.
#
function _do_mongo_stop() {
  _do_docker_util_kill "${_DO_MONGO_DOCKER_IMAGE}" || return 1
}
