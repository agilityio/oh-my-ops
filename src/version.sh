export DO_VERSION="1.0.0"

# Prints out the version of do framework.
# 
function _do_version() {
    echo "${DO_VERSION}"
}

alias do-version="_do_version"
