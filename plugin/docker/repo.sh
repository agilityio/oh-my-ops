function _do_docker() {
  local repo=${1?'repo arg required'}
  shift 1

  local cmds
  cmds='clean build status'

  # shellcheck disable=SC2068
  # shellcheck disable=SC2086
  _do_repo_plugin_cmd_add "${repo}" 'docker' $cmds $@
}
