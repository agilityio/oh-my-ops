
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

function _do_gitlab_util_project_exists() {
  local repo=${1?'repo arg required'}
  local project_name=${2?'project_name arg required'}
  local token=${3:-"$(_do_gitlab_util_authenticate "${repo}")"}

  local url
  url=$(_do_gitlab_util_api_url "$repo") || return 1
  url="${url}/projects"

  local count
  count=$(_do_curl_util_authorized_json_get "${url}" "${token}" | _do_jq_util_array_length) || return 1
  [[ $count -gt 0 ]] || return 1
}

# Creates a gitlab project with the specified name.
# Arguments:
# - repo: The repository to create the project for.
# - project_name: The project name to create.
# - token: Optional. The access token. If this is missing,
#   default root username / password shall be used to authenticate.
#
function _do_gitlab_util_create_project() {
  local repo=${1?'repo arg required'}
  local project_name=${2?'project_name arg required'}
  local token=${3:-"$(_do_gitlab_util_authenticate "${repo}")"}

  local url
  url=$(_do_gitlab_util_api_url "$repo") || return 1
  url="${url}/projects"

  local project_path
  project_path=$(_do_string_to_dash "${project_name}")

  # See: https://docs.gitlab.com/ee/api/projects.html#create-project
  _do_curl_util_authorized_json_post "${url}" "${token}" \
    "{
      \"name\":\"${project_name}\",
      \"path\":\"${project_path}\"
    }" || return 1
}
