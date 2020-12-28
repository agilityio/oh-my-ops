function _do_gitlab_util_update_application_settings() {
  local repo=${1?'repo arg required'}
  local body=${2?'body arg required'}
  local token=${3:-"$(_do_gitlab_util_authenticate "${repo}")"}

  local url
  url=$(_do_gitlab_util_api_url "$repo") || return 1
  url="${url}/application/settings"

  _do_curl_util_authorized_json_put "${url}" "${token}" "${body}" || return 1
}
