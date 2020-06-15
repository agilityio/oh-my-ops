# Runs an nx command at the specified directory.
#
# Arguments:
# 1. dir: The absolute directory to run the command.
#
# 2. cmd: The command to run.
#
#   It is ok to put any command, as long as it is defined in the package.json.
#
function _do_nx_repo_cmd() {
  local err=0
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'cmd arg required'}

  shift 3
  local opts=""

  _do_dir_push "${dir}" || return 1

  # Replaces all '::' to 'space'
  cmd=$(echo $cmd | sed -e 's/::/ /g')
  _do_log_debug 'nx' "cmd: $cmd" 

  {
    nx ${cmd} $@
  } || {
    err=1
  }

  _do_dir_pop
  return ${err}
}
