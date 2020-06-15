# Prints out help for make plugin.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#   4. sub_cmd. The sub command to displays the help for.
#
function _do_make_repo_cmd_help() {
  local sub_cmd=${4?'sub_cmd arg required'}

  case "${sub_cmd}" in
    help)
      echo "Prints this help.";;

    clean)
      echo "Perform 'make clean' to clean the repository.";;

    install)
      echo "Perform 'make install' to install the project.";;

    build)
      echo "Perform 'make build' to build the repository.";;

    start)
      echo "Perform 'make start' to starts the program.";;

    doctor)
      echo "Display some information about make.";;

  esac
}

