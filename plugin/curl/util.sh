function _do_curl_util_authorized_json_post() {
  local url=${1?'token arg required.'}
  local token=${2?'token arg required.'}
  local body=${3?'body arg required.'}

  curl -X POST -H "Authorization: Bearer ${token}" \
    -H "Content-Type: application/json" \
    -d "${body}" \
    "${url}" || return 1
}

function _do_curl_util_authorized_json_get() {
  local url=${1?'token arg required.'}
  local token=${2?'token arg required.'}

  curl -H "Authorization: Bearer ${token}" \
    -H "Content-Type: application/json" \
    "${url}" || return 1
}
