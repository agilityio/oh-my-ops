# Prints out help for nx plugin.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#   4. sub_cmd. The sub command to displays the help for.
#
function _do_nx_repo_cmd_help() {
  local sub_cmd=${4?'sub_cmd arg required'}

  case "${sub_cmd}" in
    help)
      echo "Prints this help.";;

    affected:build)
      echo "Build applications and publishable libraries affected by changes";;

    affected:test)
      echo "Test projects affected by changes";;

    affected:lint)
      echo "Lint projects affected by changes";;

    *)
      if _do_string_contains "${sub_cmd}" "::"; then
        echo "${sub_cmd//::/ } sub project".
      else
        echo "Runs nx ${sub_cmd}"
      fi

  esac
}

