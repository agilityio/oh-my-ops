# Runs a git command at a specified directory.
#
# Arguments:
#   1. dir: The directory to run the command for.
#   2. cmd: The command to run.
#       * status: Gets git status.
#
function _do_git_repo_cmd() {
  local cmd=${3?'cmd arg required'}
  shift 3

  # shellcheck disable=SC2068
  git "${cmd}" $@ || return 1
}
