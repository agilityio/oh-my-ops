# Enables vg commands for the specified repository.
# Arguments:
#   1. name: The repository name.
#
function _do_vg() {
  local name=${1?'name arg required'}
  shift 1

  _do_vg_enabled "${name}" || _do_print_warn "${name} repo is not an vg repo."

  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_repo_plugin_cmd_add "${name}" 'vg' ${DO_VG_CMDS} $@
}

# Determines if the specified repository has vg enabled.
#
function _do_vg_enabled() {
  local name=${1?'name arg required'}

  local dir
  dir=$(_do_repo_dir_get "${name}")

  # We do expects the repository to have package.json file.
  [ -f "${dir}/Vagrantfile" ] || return 1
}

