function _do_go() {
  local repo=${1?'repo arg required'}
  shift 1

  # shellcheck disable=SC2068
  _do_repo_plugin_cmd_add "${repo}" 'go' $@
}

function _do_go_cli() {
  # shellcheck disable=SC2068
  # shellcheck disable=SC2086
  _do_go $@ ${DO_GO_CLI_CMDS}
}

function _do_go_mod() {
  # shellcheck disable=SC2068
  # shellcheck disable=SC2086
  _do_go $@ ${DO_GO_MOD_CMDS}
}
