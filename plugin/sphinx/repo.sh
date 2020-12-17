# Adds a new project to the management list.
# Arguments:
#   1. dir: The project directories
#   2. name: The project custom name.
#
function _do_sphinx() {
  local name=${1?'name arg required'}
  shift 1

  local cmds="install clean build start stop status logs attach help $*"

  # shellcheck disable=SC2086
  _do_repo_plugin_cmd_add "${name}" 'sphinx' $cmds
}

# Determines if the specified repository has nx enabled.
#
function _do_sphinx_repo_enabled() {
  local dir=${1?'dir arg required'}

  # We do expects the repository to have conf.py file.
  [ -f "${dir}/conf.py" ] || return 1
}
