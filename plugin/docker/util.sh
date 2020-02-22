

# Builds the specified dir as a new docker image.
# Arguments:
#   - dir: The directory to build.
#   - image: The docker image name.
#
function _do_docker_util_build() {
  local dir=${1?'dir arg required'}
  local image=${2?'image arg required'}
  local err=0

  _do_dir_push "$dir"
  docker build . -t "$image" || err=1
  _do_dir_pop

  return $err
}


# Runs a new docker container with the specified image name.
# Arguments:
#   - image: The docker image to run
#   - container: The result's container name
#   - ...: All other arguments will be passed into
#     docker run commands as-is
#
function _do_docker_util_run() {
  local image=${1?'image arg required'}
  shift 1

  # shellcheck disable=SC2068
  docker run $@ "$image" || return 1
}


# Runs a new docker container with the specified image name as deamon.
# Arguments:
#   - image: The docker image to run.
#   - container: The result's container name.
#   - ...: All other arguments will be passed into the
#     docker run command as-is.
#
function _do_docker_util_run_deamon() {
  local image=${1?'image arg required'}
  local container=${2?'container arg required'}
  shift 2

  # Runs the specified docker image
  # --rm: removes any existing container with the same name.
  # -d: as deamon
  # shellcheck disable=SC2068
  docker run --rm -d --name "$container" $@ "$image" || return 1
}

# Dumps out logs produced by a docker container.
# Arguments:
#   - container: The container to dump the logs.
#
function _do_docker_util_logs() {
  local container=${1?'container arg required'}
  docker logs "$container" || return 1
}


# Attach to a running container.
#
# Arguments:
#   - container: The runnning container to attach to.
#
function _do_docker_util_attach() {
  local container=${1?'container arg required'}
  docker attach "$container" || return 1
}


# Kill a running container.
#
# Arguments:
#   - container: The runnning container to kill.
#
function _do_docker_util_kill() {
  local container=${1?'container arg required'}
  docker kill "$container" || return 1
}
