# Runs a gradle repository command.
# Arguments:
#   1. dir: The directory to run a gradle command.
#   2. repo: The repository to run the command.
#   3. cmd: The gradle command to run. Here are the common ones:
#       * doctor:
#       * clean: For clean up the repository.
#       * build-ios: For building the ios app.
#       * build-android: For building the android app.
#       * install: Will trigger 'gradle pub get' behind the scene
#           to download dependencies.
#
function _do_gradle_repo_cmd() {
  local cmd=${3?'arg command is required'}
  shift 3

  # For command that is not the default gradle one,
  # we need to append the "run" in front to run it with run script.
  case "${cmd}" in
  install)
    ./gradlew assemble || return 1
    ;;
  *)
    ./gradlew "${cmd}" || return 1
    ;;
  esac
}
