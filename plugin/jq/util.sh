function _do_jq_util_get() {
  local key=${1?'key is required'}
  jq -r ".${key}"
}

function _do_jq_util_array_length() {
  local key=${1:-''}
  jq ".${key} | length"
}
