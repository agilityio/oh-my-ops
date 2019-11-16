# Runs a flutter repository command.
# Arguments:
#  1. dir: The directory to run a flutter command.
#  3. cmd: The flutter command to run.
#
function _do_flutter_cmd() {
  local err=0
  local dir=${1?'dir arg is required'}
  local cmd=${2?'arg command is required'}
  shift 2

  # By default, runs with flutter command.
  local run="flutter ${cmd}"

  # Jumps to the
  _do_dir_push "${dir}" || return 1

  {
    {
      # For command that is not the default flutter one,
      # we need to append the "run" in front to run it with run script.
      case "${cmd}" in
      pub-get)
        run="flutter pub get"
        ;;
      build-android)
        run="flutter build apk"
        ;;
      build-ios)
        run="flutter build ios"
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
