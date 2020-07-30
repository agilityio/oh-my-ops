if [ -z "${DO_VERSION}" ]; then
  export DO_VERSION="1.0.0"
fi

# Prints out the version of do framework.
#
function _do_version() {
  echo "${DO_VERSION}"
}

alias do-version="_do_version"
