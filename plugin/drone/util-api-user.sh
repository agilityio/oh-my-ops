
function _do_drone_util_get_user() {
  local repo=${1?'repo arg required'}
  local token=${2:-"${_DO_DRONE_USER_TOKEN}"}

  local url
  url=$(_do_drone_util_api_url "$repo") || return 1
  url="${url}/user"

  # See: https://docs.drone.io/api/user/user_info/
  _do_curl_util_authorized_json_get "${url}" "${token}" || return 1
}


# Determines if the drone user has already logged into the UI
function _do_drone_util_is_user_login() {
  local repo=${1?'repo arg required'}
  local token=${2:-"${_DO_DRONE_USER_TOKEN}"}

  local res
  res=$(_do_drone_util_get_user "${url}" "${token}") || return 1

  # Gets the last_login field from the response json and make sure the
  # user has already login
  [[ "$(echo "${res}" | _do_jq_util_get 'last_login')" -gt 0 ]] || return 1
}

# Waits for the user to login
#
function _do_drone_util_wait_user_login() {
  local repo=${1?'repo arg required'}
  local token=${2:-"${_DO_DRONE_USER_TOKEN}"}

  if _do_drone_util_is_user_login "$repo" "${token}" &> /dev/null; then
    return
  fi

  local url
  url=$(_do_drone_util_app_url "${repo}")

  printf "Please open %s and login. Wait" "${url}"
  until _do_drone_util_is_user_login "$repo" "${token}" &> /dev/null; do
    printf "."

    # Sleep a bit before trying again
    sleep 5
  done
  printf "\n"
}
