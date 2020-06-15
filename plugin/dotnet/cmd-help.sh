# Prints out help for dotnet plugin.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#   4. sub_cmd. The sub command to displays the help for.
#
function _do_dotnet_repo_cmd_help() {
  local sub_cmd=${4?'sub_cmd arg required'}

  case "${sub_cmd}" in
    help)
      echo "Prints this help.";;

    clean)
      echo "Perform 'donet clean' to clean the repository.";;

    install)
      echo "Perform 'dotnet restore' to install the project.";;

    build)
      echo "Perform 'dotnet build' to build the repository.";;

    start)
      echo "Perform 'dotnet watch run' to starts the program.";;

  esac
}

