# Gets a secret from a drone project.
#
# Arguments:
# 1. The repository name. This is used to get the api url.
# 2. The project name. This is used to get the git project path.
# 3. The secret_name. This is the secret name.
# 4. Optional. The drone user token.
#
# Returns the output json from the drone api.
# See: https://docs.drone.io/api/secrets/secret_info/
#
function _do_drone_util_get_secret() {
  local repo=${1?'repo arg required'}
  local project_name=${2?'project_name arg required'}
  local secret_name=${3?'secret_name arg required'}
  local token=${4:-"${_DO_DRONE_USER_TOKEN}"}

  local project_path
  project_path=$(_do_string_to_dash "${project_name}")

  local url
  url=$(_do_drone_util_api_url "$repo") || return 1
  url="${url}/repos/${_DO_DRONE_USER}/${project_path}/secrets/${secret_name}"

  local res
  res=$(_do_curl_util_authorized_json_get "${url}" "${token}") || return 1

  # Gets out the newly created id and makes sure that exists
  local id
  id="$(echo "${res}" | _do_jq_util_get 'id')"
  [[ ! "${id}" == "null" ]] || return 1

  # Returns the output json.
  echo "${res}"
}


# Determines if a secret is already exists
#
# Arguments:
# 1. The repository name. This is used to get the api url.
# 2. The project name. This is used to get the git project path.
# 3. The secret_name. This is the secret name.
# 4. Optional. The drone user token.
#
function _do_drone_util_secret_exists() {
  local repo=${1?'repo arg required'}
  local project_name=${2?'project_name arg required'}
  local secret_name=${3?'secret_name arg required'}
  local token=${4:-"${_DO_DRONE_USER_TOKEN}"}

  # Gets out the secret, if exists, return true.
  _do_drone_util_get_secret "${repo}" "${project_name}" "${secret_name}" "${token}" &> /dev/null || return 1
}


# Creates a drone secret with the specified name.
#
# Arguments:
# - repo: The repository to create the secret for.
# - secret_name: The secret name to create.
# - secret_data: The secret data to create.
# - pull_request: either 'true' or 'false'.
#   See drone api documentation to understand more.
# - token: Optional. The access token. If this is missing,
#   default root username / password shall be used to authenticate.
#
# Output:
# - The newly created secret id
#
# See: https://docs.drone.io/api/secrets/secret_create/
#
function _do_drone_util_create_secret() {
  local repo=${1?'repo arg required'}
  local project_name=${2?'project_name arg required'}
  local secret_name=${3?'secret_name arg required'}
  local secret_data=${4?'secret_data arg required'}
  local pull_request=${5?'pull_request arg required'}
  local token=${6:-"${_DO_DRONE_USER_TOKEN}"}

  local project_path
  project_path=$(_do_string_to_dash "${project_name}")

  local url
  url=$(_do_drone_util_api_url "$repo") || return 1
  url="${url}/repos/${_DO_DRONE_USER}/${project_path}/secrets"

  local res
  res=$(_do_curl_util_authorized_json_post "${url}" "${token}" \
    "{
      \"name\": \"${secret_name}\",
      \"data\": \"${secret_data}\",
      \"pull_request\": ${pull_request}
    }") || return 1

  # Gets out the newly created id and make sure that is not null.
  local id
  id="$(echo "${res}" | _do_jq_util_get 'id')"
  [[ ! "${id}" == "null" ]] || return 1

  # Returns the newly created secret id
  echo "${id}"
}


# Creates a drone secret with the specified name if does not exists.
# Arguments:
# - repo: The repository to create the secret for.
# - secret_name: The secret name to create.
# - secret_data: The secret data to create.
# - pull_request: either 'true' or 'false'.
#   See drone api documentation to understand more.
# - token: Optional. The access token. If this is missing,
#   default root username / password shall be used to authenticate.
#
# Output:
# - The newly created secret id
#
function _do_drone_util_create_secret_if_missing() {
  local repo=${1?'repo arg required'}
  local project_name=${2?'project_name arg required'}
  local secret_name=${3?'secret_name arg required'}
  local secret_data=${4?'secret_data arg required'}
  local pull_request=${5?'pull_request arg required'}
  local token=${6:-"${_DO_DRONE_USER_TOKEN}"}

  local res
  res=$(_do_drone_util_get_secret "${repo}" "${project_name}" "${secret_name}" "${token}") || {
    # Creates a new secret
    _do_drone_util_create_secret "${repo}" "${project_name}" "${secret_name}" "${secret_data}" "${pull_request}" "${token}" ||
      return 1
  }

  # Gets out the id and return
  local id
  id="$(echo "${res}" | _do_jq_util_get 'id')"

  echo "${id}"
}

