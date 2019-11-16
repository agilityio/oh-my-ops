# Runs a flutter repository command.
# Arguments:
#   1. dir: The directory to run a flutter command.
#   2. repo: The repository to run the command.
#   3. cmd: The flutter command to run. Here are the common ones:
#       * doctor:
#       * clean: For clean up the repository.
#       * build-ios: For building the ios app.
#       * build-android: For building the android app.
#       * install: Will trigger 'flutter pub get' behind the scene
#           to download dependencies.
#
function _do_flutter_repo_cmd() {
  local err=0
  local dir=${1?'dir arg is required'}
  local repo=${2?'repo arg required'}
  local cmd=${3?'arg command is required'}
  shift 3

  # By default, runs with flutter command.
  local run="flutter ${cmd}"

  # Jumps to the
  _do_dir_push "${dir}" || return 1

  {
    {
      # For command that is not the default flutter one,
      # we need to append the "run" in front to run it with run script.
      case "${cmd}" in
      install)
        run="flutter pub get"
        ;;
      build:android)
        run="flutter build apk"
        ;;
      build:ios)
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
