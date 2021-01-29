function _do_docker_compose_repo_cmd() {
  local cmd=${3?'arg command is required'}
  shift 3

  case "${cmd}" in
  start)
    docker-compose up
    ;;
  stop)
    docker-compose down
    ;;
  build)
    docker-compose build --no-cache || return 1
    ;;
  *)
    # shellcheck disable=SC2068
    docker-compose $@
    ;;
  esac
}
