# Prints out help for tmux plugin.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#   4. sub_cmd. The sub command to displays the help for.
#
function _do_tmux_repo_cmd_help() {
  local sub_cmd=${4?'sub_cmd arg required'}

  case "${sub_cmd}" in
    help)
      echo "Prints this help.";;

    start)
      echo "Starts the repository's tmux session.";;

    stop)
      echo "Stops the repository's tmux session.";;
  esac
}

