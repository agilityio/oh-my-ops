# Adds a new project to the management list.
# Arguments:
#   1. dir: The project custom name.
#   2. repo: The repository name.
#
function _do_git_repo_add() {
  local repo=${1?'repo arg required'}
  shift 1

  _do_repo_plugin_cmd_add "${repo}" 'git' 'init' 'status'

  if [[ $# -gt 0 ]]; then
    _do_repo_plugin_cmd_add "${repo}" 'git' $@
  fi
}
