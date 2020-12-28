# Gets the default docker image name for the given repository.
# Arguments:
#   1. repo: The repository name.
#
function _do_drone_docker_image_name() {
  local repo=${1?'repo arg required'}
  echo "do-${repo}-drone"
}

# Gets the default docker container name for the given repository.
# Arguments:
#   1. repo: The repository name.
#
function _do_drone_docker_container_name() {
  local repo=${1?'repo arg required'}
  echo "do-${repo}-drone"
}

# Gets the default docker image name for the given repository.
# Arguments:
#   1. repo: The repository name.
#
function _do_drone_runner_docker_image_name() {
  local repo=${1?'repo arg required'}
  echo "do-${repo}-drone-runner"
}


# Gets the default docker container name for the given repository.
# Arguments:
#   1. repo: The repository name.
#
function _do_drone_runner_docker_container_name() {
  local repo=${1?'repo arg required'}
  echo "do-${repo}-drone-runner"
}
