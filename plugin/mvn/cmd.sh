# Runs an mvn command at the specified directory.
#
# Arguments:
# 1. dir: The absolute directory to run the command.
# 2. repo: The repo name
#
# 3. cmd: The command to run.
#
function _do_mvn_repo_cmd() {
  local err=0
  local cmd=${3?'cmd arg required'}
  shift 3
  local opts
  opts=""

  case "${cmd}" in
    install | package | deploy)
      opts="-Dmaven.test.skip=true";
      ;;

    build)
      cmd="compile";
      opts="-Dmaven.test.skip=true";
      ;;

  esac

  {
      # shellcheck disable=SC2068
      # shellcheck disable=SC2086
      mvn "${cmd}" ${opts} $@
  } || {
    err=1
  }

  return ${err}
}
