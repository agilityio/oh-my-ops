function _do_gitlab_util_app_url() {
  local repo=${1?'repo arg required'}
  echo "http://localhost:${_DO_GITLAB_HTTP_PORT}"
}

function _do_gitlab_util_api_url() {
  # shellcheck disable=SC2034
  local repo=${1?'repo arg required'}
  echo "http://localhost:${_DO_GITLAB_HTTP_PORT}/api/${_DO_GITLAB_API_VERSION}"
}

function _do_gitlab_util_authenticate() {
  local repo=${1?'repo arg required'}
  local username=${2:-"${_DO_GITLAB_USER}"}
  local password=${3:-"${_DO_GITLAB_PASS}"}

  local url
  url=$(_do_gitlab_util_app_url "$repo") || return 1
  url="${url}/oauth/token"

  local res
  res=$(curl -X POST -d "grant_type=password&username=${username}&password=${password}" "${url}") || return 1

  echo "${res}" | _do_jq_util_get 'access_token'
}
