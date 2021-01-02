# Determines if the specified docker image file exists.
# Arguments:
#   1. image: The image name.
#
function _do_docker_util_image_exists() {
  local image=${1?'image arg required'}

  # Runs the docker images -q command to get out the image id.
  # If that is not null then the image exists.
  #
  [ "$(docker images -q "${image}" 2>/dev/null)" != "" ] || return 1
}

# Builds the specified dir as a new docker image.
# Arguments:
#   - dir: The directory to build.
#   - image: The docker image name.
#
function _do_docker_util_build_image() {
  local dir=${1?'dir arg required'}
  local image=${2?'image arg required'}
  local err=0

  _do_dir_push "$dir"
  docker build . -t "$image" || err=1
  _do_dir_pop

  return $err
}

# Removes the specified docker image.
# Arguments:
#   1. image: The docker image to remove.
#
function _do_docker_util_remove_image() {
  local image=${1?'image arg required'}

  # Removes the image if that do exist
  ! _do_docker_util_image_exists "${image}" || docker rmi -f "${image}" || return 1
}


# Asserts that the docker image exists.
#
function _do_docker_assert_image_exists() {
  local image=${1?'image arg required'}

  _do_docker_util_image_exists "$image" ||
    _do_assert_fail "Expected docker image '${image}' exists"
}


# Asserts that the docker image does not exist.
# Arguments:
#   1. image: The docker image to check.
#
function _do_docker_assert_image_not_exists() {
  local image=${1?'image arg required'}
  ! _do_docker_util_image_exists "$image" ||
    _do_assert_fail "Expected docker image '${image}' not exists"
}
