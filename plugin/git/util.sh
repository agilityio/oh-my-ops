# Gets the git root directory of the current dir
#
function _do_git_util_get_root() {
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
