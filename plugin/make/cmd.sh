# Runs a make repository command.
# Arguments:
#   1. dir: The directory to run a make command.
#   2. repo: The repository to run the command.
#   3. cmd: The make command to run. Here are the common ones:
#     ...
#
function _do_make_repo_cmd() {
  local cmd=${3?'arg command is required'}
  shift 3

  # By default, runs with make command.
  local run="make ${cmd}"

  # shellcheck disable=SC2068
  {
    {
      case "${cmd}" in
      doctor)
        run='make --version'
        ;;
      esac
    } &&
      ${run} $@
  } || return 1
}
