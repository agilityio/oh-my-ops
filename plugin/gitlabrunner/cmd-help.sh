# Prints out help for gitlabrunner plugin.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#   4. sub command. The sub command to displays the help for.
#
function _do_gitlabrunner_repo_cmd_help() {
  local sub_cmd=${4?'repo arg required'}

  case "${sub_cmd}" in
    help)
      echo "Prints this help.";;

    install)
      echo "Builds gitlabrunner docker image to local." ;;

    status)
      echo "Displays server status.";;

    logs)
      echo "Displays the most recent logs in the server.";;

    attach)
      echo "Attach to the server to see logs live.";;

    start)
      echo "Starts the gitlabrunner server.";;

    stop)
      echo "Stops the gitlabrunner server.";;
  esac
}

