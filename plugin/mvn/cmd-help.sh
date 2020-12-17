# Prints out help for mvn plugin.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#   4. sub_cmd. The sub command to displays the help for.
#
function _do_mvn_repo_cmd_help() {
  local sub_cmd=${4?'sub_cmd arg required'}

  case "${sub_cmd}" in
  help)
    echo "Prints this help."
    ;;

  clean)
    echo "Clean the project."
    ;;

  build)
    echo "compile the source code of the project."
    ;;

  test)
    echo "test the compiled source code using a suitable unit testing framework.
    These tests should not require the code be packaged or deployed."
    ;;

  package)
    echo "take the compiled code and package it in its distributable format, such as a JAR."
    ;;

  verify)
    echo "run any checks on results of integration tests to ensure quality criteria are met"
    ;;

  install)
    echo "install the package into the local repository,
    for use as a dependency in other projects locally."
    ;;

  deploy)
    echo "done in the build environment, copies the final package to the remote repository
    for sharing with other developers and projects."
    ;;
  esac
}
