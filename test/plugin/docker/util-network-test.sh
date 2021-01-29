_do_plugin "docker"

function test_util_network() {
  local name
  name="fake-network"

  # Just remove the network, just in case that still exists
  _do_docker_util_remove_network "${name}"

  _do_docker_assert_network_not_exists "${name}"
  _do_docker_util_create_bridge_network "${name}" || _do_assert_fail

  _do_docker_util_create_bridge_network_if_missing "${name}" || _do_assert_fail

  _do_docker_assert_network_exists "${name}"
  _do_docker_util_remove_network "${name}" || _do_assert_fail
  _do_docker_assert_network_not_exists "${name}"
}


function test_util_default_network() {
  local name
  name="${_DO_DOCKER_NETWORK}"

  _do_docker_util_create_default_network_if_missing  || _do_assert_fail
  _do_docker_assert_network_exists "${name}"

  _do_docker_util_remove_default_network  || _do_assert_fail
  _do_docker_assert_network_not_exists "${name}"
}
