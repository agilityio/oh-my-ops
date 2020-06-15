# Adds a new project to the management list.
# Arguments:
#   1. repo: The repository name.
#
function _do_make() {
  local repo=${1?'repo arg required'}
  shift 1

  # shellcheck disable=SC2068
  # shellcheck disable=SC2086
  _do_repo_plugin_cmd_add "${repo}" 'make' $@
}

function _do_make_lib() {
  # shellcheck disable=SC2068
  _do_make $@
}

function _do_make_api() {
  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_make $@ ${DO_MAKE_API_CMDS}
}

function _do_make_cli() {
  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_make $@ ${DO_MAKE_CLI_CMDS}
}

function _do_make_web() {
  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_make $@ ${DO_MAKE_WEB_CMDS}
}
