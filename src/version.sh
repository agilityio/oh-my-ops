# Prints out the version of do framework.
#
function _do_version() {
  local ver="${DO_VERSION}"
  if [ -z "${ver}" ]; then
    # This should be the latest version.
    ver="0.1"
  fi
  echo "${ver}"
}

