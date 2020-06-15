# Prints out help for npm plugin.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#   4. sub_cmd. The sub command to displays the help for.
#
function _do_npm_repo_cmd_help() {
  local sub_cmd=${4?'sub_cmd arg required'}

  case "${sub_cmd}" in
    help)
      echo "Prints this help.";;

    install)
      echo "Prints out this help.";;

    clean)
      echo "Runs 'npm run clean' to clean the repository.";;
  esac
}

