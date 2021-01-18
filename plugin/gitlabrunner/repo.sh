# Adds a new project to the management list.
# Arguments:
#   1. dir: The project directories
#   2. name: The project custom name.
#
function _do_gitlabrunner() {
  local name=${1?'name arg required'}
  shift 1

  local cmds="install start stop status logs attach help $*"

  # shellcheck disable=SC2086
  _do_repo_plugin_cmd_add "${name}" 'gitlabrunner' $cmds
}
