function _do_drone_util_get_project() {
  local repo=${1?'repo arg required'}
  local project_name=${2?'project_name arg required'}
  local token=${3:-"${_DO_DRONE_USER_TOKEN}"}

  local project_path
  project_path=$(_do_string_to_dash "${project_name}")

  local url
  url=$(_do_drone_util_api_url "$repo") || return 1
  url="${url}/repos/${_DO_DRONE_USER}/${project_path}"

  # Gets out the active field of the json response.
  # Makes sure the repository is active.
  local res
  res=$(_do_curl_util_authorized_json_get "${url}" "${token}") || return 1

  # Gets out the newly created id and makes sure that exists
  local id
  id="$(echo "${res}" | _do_jq_util_get 'id')"
  [[ ! "${id}" == "null" ]] || return 1

  # Returns the output json.
  echo "${res}"
}

function _do_drone_util_project_exists() {
  local repo=${1?'repo arg required'}
  local project_name=${2?'project_name arg required'}
  local token=${3:-"${_DO_DRONE_USER_TOKEN}"}

  # Gets out the active field of the json response.
  # Makes sure the repository is active.
  local active
  active=$(_do_drone_util_get_project "${repo}" "${project_name}" "${token}" | _do_jq_util_get 'active') || return 1

  [[ "${active}" == "true" ]] || return 1
}

# Creates a drone project with the specified name.
# Arguments:
# - repo: The repository to create the project for.
# - project_name: The project name to create.
# - token: Optional. The access token. If this is missing,
#   default root username / password shall be used to authenticate.
#
# See: https://docs.drone.com/ee/api/projects.html#create-project
function _do_drone_util_create_project() {
  local repo=${1?'repo arg required'}
  local project_name=${2?'project_name arg required'}
  local token=${3:-"${_DO_DRONE_USER_TOKEN}"}

  local project_path
  project_path=$(_do_string_to_dash "${project_name}")

  local url
  url=$(_do_drone_util_api_url "$repo") || return 1
  url="${url}/repos/${_DO_DRONE_USER}/${project_path}"

  local res
  res=$(_do_curl_util_authorized_json_post "${url}" "${token}" "{}") || return 1

  # Gets out the newly created id and makes sure that exists.
  local id
  id="$(echo "${res}" | _do_jq_util_get 'id')"
  [[ ! "${id}" == "null" ]] || return 1

  # Returns the output json.
  echo "${res}"
}

# Creates a drone project with the specified name if does not exists.
# Arguments:
# - repo: The repository to create the project for.
# - project_name: The project name to create.
# - token: Optional. The access token. If this is missing,
#   default root username / password shall be used to authenticate.
#
function _do_drone_util_create_project_if_missing() {
  local repo=${1?'repo arg required'}
  local project_name=${2?'project_name arg required'}
  local token=${3:-"${_DO_DRONE_USER_TOKEN}"}

  local res

  res=$(_do_drone_util_project_exists "${repo}" "${project_name}" "${token}") || {
    # Creates a new project if that does not exists
    _do_drone_util_create_project "${repo}" "${project_name}" "${token}" ||
      return 1
  }

  # Gets out the id and return
  local id
  id="$(echo "${res}" | _do_jq_util_get 'id')"

  echo "${id}"
}
