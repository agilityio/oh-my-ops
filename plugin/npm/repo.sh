# Adds a new project to the management list.
# Arguments:
#   1. dir: The project directories
#   2. name: The project custom name.
#
function _do_npm() {
  local name=${1?'name arg required'}
  shift 1

  _do_repo_plugin_cmd_add "${name}" 'npm' "install" "clean" $@
}

function _do_npm_angular() {
  local name=${1?'name arg required'}
  shift 1

  _do_repo_plugin_cmd_add "${name}" 'npm' 'install' 'clean' 'start' 'build' 'test' 'lint' 'e2e' 'ng' $@
}

function _do_npm_api() {
  local name=${1?'name arg required'}
  shift 1

  _do_repo_plugin_cmd_add "${name}" 'npm' 'clean' 'start' 'lint' \
    'build' 'test' 'lint' 'e2e' $@
}
