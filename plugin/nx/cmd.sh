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
  local cmd=${3?'cmd arg required'}

  shift 3

  # Replaces all '::' to 'space'
  cmd=${cmd//::/ }

  {
    # shellcheck disable=SC2086
    # shellcheck disable=SC2068
    nx ${cmd} $@
  } || {
    err=1
  }

  return ${err}
}
