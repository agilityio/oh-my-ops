function _do_drone_util_app_url() {
  local repo=${1?'repo arg required'}
  echo "http://localhost:${_DO_DRONE_HTTP_PORT}"
}

function _do_drone_util_api_url() {
  # shellcheck disable=SC2034
  local repo=${1?'repo arg required'}
  echo "http://localhost:${_DO_DRONE_HTTP_PORT}/api"
}
