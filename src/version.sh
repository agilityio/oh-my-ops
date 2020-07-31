
# Prints out the version of do framework.
#
function _do_version() {
  local ver="${DO_VERSION}"
  if [ -z "${ver}" ]; then
    # This should be the latest version.
    ver="1.0.0"
  fi
  echo "${ver}"
}

alias do-version="_do_version"
