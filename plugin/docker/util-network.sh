# Creates a bridge docker network.
# Arguments:
# 1. name: The network name.
#
function _do_docker_util_create_bridge_network() {
  local name=${1?'name arg required'}
  docker network create --driver bridge "$name" || return 1
}

# Creates a bridge docker network.
# Arguments:
# 1. name: The network name.
#
function _do_docker_util_create_bridge_network_if_missing() {
  local name=${1?'name arg required'}
  _do_docker_util_network_exists "${name}" ||
    _do_docker_util_create_bridge_network "${name}" ||
    return 1
}

function _do_docker_util_create_default_network_if_missing() {
  _do_docker_util_create_bridge_network_if_missing "${_DO_DOCKER_NETWORK}" || return 1
}

# Removes an existing docket network, specified by its name.
# Arguments:
# 1. name: The network name.
#
function _do_docker_util_remove_network() {
  local name=${1?'name arg required'}
  docker network rm "$name" || return 1
}

function _do_docker_util_remove_default_network() {
  _do_docker_util_remove_network "${_DO_DOCKER_NETWORK}" || return 1
}

# Determines if the specified network exists or not.
# Arguments:
#   1. name: The network name
#
function _do_docker_util_network_exists() {
  local name=${1?'name arg required'}
  docker network inspect "${name}" &>/dev/null || return 1
}

# Asserts that the specified network exists.
# Arguments:
#   1. name: The network name to check.
#
function _do_docker_assert_network_exists() {
  local name=${1?'name arg required'}

  _do_docker_util_network_exists "${name}" ||
    _do_assert_fail "Expected docker network '${name}' exists"
}

# Asserts that the specified network does not exists.
# Arguments:
#   1. name: The name name to check.
#
function _do_docker_assert_network_not_exists() {
  local name=${1?'name arg required'}
  ! _do_docker_util_network_exists "${name}" ||
    _do_assert_fail "Expected docker network '${name}' not exists"
}

