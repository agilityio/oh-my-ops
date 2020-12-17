# Prints out help for sphinx plugin.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#   4. sub command. The sub command to displays the help for.
#
function _do_sphinx_repo_cmd_help() {
  local sub_cmd=${4?'repo arg required'}

  case "${sub_cmd}" in
    help)
      echo "Prints this help.";;

    install)
      echo "Builds sphinx docker image to local." ;;

    build)
      echo "Builds the document.";;

    logs)
      echo "Displays the most recent logs in the server.";;

    attach)
      echo "Attach to the server to see logs live.";;

    status)
      echo "Displays information about the sphinx plugin.";;

    start)
      echo "Starts the neo4j server.";;

    stop)
      echo "Stops the neo4j server.";;

  esac
}

