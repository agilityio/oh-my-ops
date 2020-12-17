# Runs a git command at a specified directory.
#
# Arguments:
#   1. dir: The directory to run the command for.
#   2. cmd: The command to run.
#       * status: Gets git status.
#
function _do_git_repo_cmd() {
  local err=0
  local dir=${1?'dir arg required'}
  local cmd=${3?'cmd arg required'}

  shift 3

  _do_dir_push "${dir}" || return 1

  {
    # shellcheck disable=SC2068
    git "${cmd}" $@
  } || {
    err=1
  }

  _do_dir_pop

  return ${err}
}
