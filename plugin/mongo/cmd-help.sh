# Prints out help for mongo plugin.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#   4. sub command. The sub command to displays the help for.
#
function _do_mongo_repo_cmd_help() {
  local sub_cmd=${4?'repo arg required'}

  case "${sub_cmd}" in
    help)
      echo "Prints this help.";;

    install)
      echo "Builds mongodb docker image to local." ;;

    status)
      echo "Displays server status.";;

    start)
      echo "Starts the mongo server.";;

    stop)
      echo "Stops the mongo server.";;
  esac
}

