# Waits for the url for the specified times out
#
# Arguments:
#  1. url. Required. The url to wait for result.
#  2. timeout. Required. An integer, which is the number of seconds to wait for.
#
function _do_curl_wait_url() {
  local url=${1?'url arg required.'}

  # Converts timeout to number
  local timeout=$((${2?'timeout arg required.'} + 0))

  local start_time=$(date +%s)

  local err=0
  until curl --silent --head --max-time 5 "${url}" &>/dev/null; do

    local end_time=$(date +%s)
    if [ ! -z "${timeout}" ] && [ $((end_time - start_time)) -gt ${timeout} ]; then
      # Exceed timeout setting.
      err=1
      break
    fi

    # Sleeps before trying again.
    sleep 5
  done

  return $err
}

# Determines whether or not the specified url exists.
#
# Arguments:
#  1. url: Required. The url to check.
#
# Returns:
#  0 if the url exists. Otherwise, return 1.
#
function _do_curl_url_exist() {
  local url=${1?'url arg required'}

  # Try to get the head of the specified url.
  # If the request return 200 means the url is available.
  if curl --silent --head --max-time 1 --fail ${url} &>/dev/null; then
    return 0
  else
    return 1
  fi
}

# Makes sure that the specified url exists.
#
# Arguments:
#  1. url: Required. The url to check.
#
function _do_curl_assert() {
  local url=${1?'url arg required'}

  _do_curl_url_exist ${url} || _do_assert_fail "Expect '${url}' to be available"
}

# Makes sure that the specified url does not exists.
#
# Arguments:
#  1. url: Required. The url to check.
function _do_curl_assert_not() {
  local url=${1?'url arg required'}

  ! _do_curl_url_exist ${url} || _do_assert_fail "Expected '${url}' to be unavailable."
}
