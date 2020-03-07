# Prints out help for go plugin.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#   4. sub_cmd. The sub command to displays the help for.
#
function _do_go_repo_cmd_help() {
  local sub_cmd=${4?'sub_cmd arg required'}

  case "${sub_cmd}" in
    help)
      echo "Prints this help.";;

    clean)
      echo "Perform 'go clean' to clean the repository.";;

    install)
      echo "Perform 'go install' to install the project.";;

    gen)
      echo "Perform 'go generate' to generate source for the repository";;

    build)
      echo "Perform 'go build' to build the repository.";;

    test)
      echo "Perform 'go test' to test the repository.";;

    get)
      echo "Perform 'go get' to add dependency to the repository.";;

    mod)
      echo "Perform 'go mod' to run module management command";;

    tidy)
      echo "Perform 'go mod tidy' to clean up the repository module.";;

    doctor)
      echo "Perform 'go env' print out the repository environment vars.";;

    start)
      echo "Perform 'go run .' to starts the program.";;

  esac
}

