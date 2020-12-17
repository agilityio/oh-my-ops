# Prints out help for vg plugin.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#   4. sub_cmd. The sub command to displays the help for.
#
function _do_vg_repo_cmd_help() {
  local sub_cmd=${4?'sub_cmd arg required'}

  case "${sub_cmd}" in
  help)
    echo "Prints this help."
    ;;

  clean)
    echo "Clean the project."
    ;;

  install)
    echo "provisions the vagrant machine."
    ;;

  build)
    echo "restarts vagrant machine, loads new Vagrantfile configuration."
    ;;

  start)
    echo "starts and provisions the vagrant environment."
    ;;

  stop)
    echo "stops the vagrant machine."
    ;;

  status)
    echo "outputs status of the vagrant machine."
    ;;

  package)
    echo "packages a running vagrant environment into a box."
    ;;

  suspend)
    echo "suspends the machine."
    ;;

  resume)
    echo "resume a suspended vagrant machine."
    ;;

  attach)
    echo "connects to machine via SSH."
    ;;

  validate)
    echo "validates the Vagrantfile."
    ;;

  esac
}
