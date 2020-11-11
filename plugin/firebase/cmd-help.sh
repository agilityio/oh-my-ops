# Prints out help for firebase plugin.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#   4. sub_cmd. The sub command to displays the help for.
#
function _do_firebase_repo_cmd_help() {
  local sub_cmd=${4?'sub_cmd arg required'}

  case "${sub_cmd}" in
    help)
      echo "Prints this help.";;

    login)
      echo "Log the CLI into Firebase.";;

    logout)
      echo "Log the CLI out of Firebase.";;

    start)
      echo "Starts the firebase emulator.";;

    deploy)
      echo "Deploys all to firebase.";;

    deploy-hosting)
      echo "Deploys only hosting to Firebase.";;

    deploy-function)
      echo "Deploys only cloud functions to Firebase.";;

    deploy-firestore)
      echo "Deploys only firestore rules to Firebase.";;

    deploy-storage)
      echo "Deploys only storage rules to Firebase.";;

    cli)
      echo "Runs firebase cli.";;

  esac
}

