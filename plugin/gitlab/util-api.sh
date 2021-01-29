function _do_gitlab_util_app_url() {
  local repo=${1?'repo arg required'}
  echo "http://${_DO_DOCKER_HOST_NAME}:${_DO_GITLAB_HTTP_PORT}"
}

function _do_gitlab_util_git_repo_url() {
  local repo=${1?'repo arg required'}
  local user=${2?'user arg required'}
  local path=${3?'path arg required'}
  echo "$(_do_gitlab_util_app_url "${repo}")/${user}/${path}.git"
}

function _do_gitlab_util_root_user_git_repo_url() {
  local repo=${1?'repo arg required'}
  local path=${2?'path arg required'}
  echo "http://${_DO_GITLAB_USER}:${_DO_GITLAB_PASS}@${_DO_DOCKER_HOST_NAME}:${_DO_GITLAB_HTTP_PORT}/${_DO_GITLAB_USER}/${path}.git"
}

function _do_gitlab_util_api_url() {
  # shellcheck disable=SC2034
  local repo=${1?'repo arg required'}
  echo "http://${_DO_DOCKER_HOST_NAME}:${_DO_GITLAB_HTTP_PORT}/api/${_DO_GITLAB_API_VERSION}"
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
