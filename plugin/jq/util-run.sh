function _do_jq_util_run() {
  _do_jq_util_install_if_missing || return 1

  # shellcheck disable=SC2068
  docker run --rm -i "${_DO_JQ_DOCKER_IMAGE}" jq "$@" || return 1
}

function _do_jq_util_get() {
  local key=${1?'key is required'}
  _do_jq_util_run -r ".${key}"
}

function _do_jq_util_array_length() {
  local key=${1:-''}
  _do_jq_util_run ".${key} | length"
}
