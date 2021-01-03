# Runs a dotnet repository command.
# Arguments:
#   1. dir: The directory to run a dotnet command.
#   2. repo: The repository to run the command.
#   3. cmd: The dotnet command to run. Here are the common ones:
#     ...
#
function _do_dotnet_repo_cmd() {
  local cmd=${3?'arg command is required'}
  shift 3

  # For command that is not the default dotnet one,
  # we need to append the "run" in front to run it with run script.
  case "${cmd}" in
  install)
    dotnet restore || return 1
    ;;
  start)
    dotnet watch run || return 1
    ;;
  *)
    # shellcheck disable=SC2068
    dotnet "${cmd}" $@ || return 1
  esac

}
