# Gets the git root directory of the current dir
#
# Arguments:
#   1. dir: A git directory to test
#
function _do_git_util_get_root_dir() {
  local dir
  dir=$(git rev-parse --show-toplevel)

  local err
  err=$?

  if _do_error $err; then
    echo ""
  else
    echo "$dir"
  fi
}
