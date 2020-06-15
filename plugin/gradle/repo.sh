# Adds a new project to the management list.
# Arguments:
#   1. dir: The project custom name.
#   2. repo: The repository name.
#
function _do_gradle_lib() {
  local repo=${1?'repo arg required'}
  shift 1

  _do_repo_plugin_cmd_add "${repo}" 'gradle' 'clean' 'install' 'build' 'test' 'lint' $@
}

function _do_gradle_mobile() {
  _do_gradle_lib $@ 'run'
}
