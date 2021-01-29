function _do_docker_compose() {
  local repo=${1?'repo arg required'}
  shift 1

  # shellcheck disable=SC2068
  # shellcheck disable=SC2086
  _do_repo_plugin_cmd_add "${repo}" 'docker-compose' ${_DO_DOCKER_COMPOSE_CMDS} $@
}
