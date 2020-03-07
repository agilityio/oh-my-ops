# Enables npm commands for the specified repository.
# Arguments:
#   1. name: The repository name.
#
function _do_npm() {
  local name=${1?'name arg required'}
  shift 1

  local cmds
  cmds="install test clean help $*"

  _do_npm_enabled "${name}" || _do_print_warn "${name} repo is not an npm repo."

  # shellcheck disable=SC2086
  _do_repo_plugin_cmd_add "${name}" 'npm' ${cmds}
}

# Determines if the specified repository has npm enabled.
#
function _do_npm_enabled() {
  local name=${1?'name arg required'}

  local dir
  dir=$(_do_repo_dir_get "${name}")

  # We do expects the repository to have package.json file.
  [ -f "${dir}/package.json" ] || return 1
}

function _do_npm_angular() {
  local name=${1?'name arg required'}
  shift 1

  # shellcheck disable=SC2068
  _do_repo_plugin_cmd_add "${name}" 'npm' "${DO_NPM_CMDS}" $@
}

