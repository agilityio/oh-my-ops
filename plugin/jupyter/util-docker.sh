# Gets the default docker image name for the given repository.
# Arguments:
#   1. repo: The repository name.
#
function _do_jupyter_docker_image_name() {
  local repo=${1?'repo arg required'}
  echo "do-${repo}-jupyter"
}


# Gets the default docker container name for the given repository.
# Arguments:
#   1. repo: The repository name.
#
function _do_jupyter_docker_container_name() {
  local repo=${1?'repo arg required'}
  echo "do-${repo}-jupyter"
}
