function _do_docker_process_exists() {
  local name=$1
  if [ "$(docker ps -q -f name="${name}")" ]; then
    return 0
  else
    return 1
  fi
}

function _do_docker_assert_process_exists() {
  local name=$1
  _do_docker_process_exists "$name" || _do_assert_fail "Expected docker process '${name}' exists"
}

function _do_docker_assert_process_not_exists() {
  local name=$1
  ! _do_docker_process_exists "$name" || _do_assert_fail "Expected docker process '${name}' not exists"
}
