# Runs an vg command at the specified directory.
#
# Arguments:
# 1. dir: The absolute directory to run the command.
# 2. repo: The repo name
#
# 3. cmd: The command to run.
#
function _do_vg_repo_cmd() {
  local err=0
  local cmd=${3?'cmd arg required'}
  shift 3

  case "${cmd}" in
  install)
    cmd="provision"
    ;;

  build)
    cmd="reload"
    ;;

  start)
    cmd="up"
    ;;

  stop)
    cmd="halt"
    ;;

  attach)
    cmd="ssh"
    ;;

  esac

  {
    # shellcheck disable=SC2068
    vagrant "${cmd}" $@
  } || {
    err=1
  }

  return ${err}
}
