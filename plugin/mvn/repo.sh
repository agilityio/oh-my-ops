# Enables mvn commands for the specified repository.
# Arguments:
#   1. name: The repository name.
#
function _do_mvn() {
  local name=${1?'name arg required'}
  shift 1

  _do_mvn_enabled "${name}" || _do_print_warn "${name} repo is not an mvn repo."

  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_repo_plugin_cmd_add "${name}" 'mvn' ${DO_MVN_CMDS} $@
}

# Determines if the specified repository has mvn enabled.
#
function _do_mvn_enabled() {
  local name=${1?'name arg required'}

  local dir
  dir=$(_do_repo_dir_get "${name}")

  # We do expects the repository to have package.json file.
  [ -f "${dir}/pom.xml" ] || return 1
}

