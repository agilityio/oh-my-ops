# Runs a dotnet repository command.
# Arguments:
#   1. dir: The directory to run a dotnet command.
#   2. repo: The repository to run the command.
#   3. cmd: The dotnet command to run. Here are the common ones:
#     ...
#
function _do_dotnet_repo_cmd() {
  local err=0
  local dir=${1?'dir arg is required'}
  local cmd=${3?'arg command is required'}
  shift 3

  # By default, runs with dotnet command.
  local run="dotnet ${cmd}"

  # Jumps to the
  _do_dir_push "${dir}" || return 1

  # shellcheck disable=SC2068
  {
    {
      # For command that is not the default dotnet one,
      # we need to append the "run" in front to run it with run script.
      case "${cmd}" in
      install)
        run='dotnet restore'
        ;;
      start)
        run='dotnet watch run'
        ;;
      esac
    } &&
      ${run} $@
  } || {
    err=1
  }

  _do_dir_pop

  return ${err}
}
