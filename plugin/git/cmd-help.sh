# Prints out help for git plugin.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#   4. sub command. The sub command to displays the help for.
#
function _do_git_repo_cmd_help() {
  local sub_cmd=${4?'sub_cmd arg required'}

  case "${sub_cmd}" in
    help)
      echo "Prints this help.";;

    status)
      echo "Displays the repository status.";;
  esac
}

