function _do_docker() {
  local repo=${1?'repo arg required'}
  shift 1

  _do_docker_enabled "${repo}" || {
    _do_print_warn "${repo} repo is not an docker repo." &&
     return 1
  }

  # shellcheck disable=SC2068
  # shellcheck disable=SC2086
  _do_repo_plugin_cmd_add "${repo}" 'docker' ${_DO_DOCKER_CMDS} $@
}

# Determines if the specified repository has docker enabled.
#
function _do_docker_enabled() {
  local repo=${1?'repo arg required'}

  local dir
  dir=$(_do_repo_dir_get "${repo}")

  # We do expects the repository to have package.json file.
  [ -f "${dir}/Dockerfile" ] || return 1
}

