# Prints out help for neo4j plugin.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#   4. sub command. The sub command to displays the help for.
#
function _do_neo4j_repo_cmd_help() {
  local sub_cmd=${4?'repo arg required'}

  case "${sub_cmd}" in
    help)
      echo "Prints this help.";;

    install)
      echo "Builds neo4jdb docker image to local." ;;

    status)
      echo "Displays server status.";;

    logs)
      echo "Displays the most recent logs in the server.";;

    attach)
      echo "Attach to the server to see logs live.";;

    start)
      echo "Starts the neo4j server.";;

    stop)
      echo "Stops the neo4j server.";;
  esac
}

