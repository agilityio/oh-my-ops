# Enables nx commands for the specified repository.
# Arguments:
#   1. name: The repository name.
#
function _do_nx() {
  local name=${1?'name arg required'}
  shift 1

  _do_nx_enabled "${name}" || _do_print_warn "${name} repo is not an nx repo."

  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_repo_plugin_cmd_add "${name}" 'nx' ${DO_NX_CMDS} $@
}

function _do_nx_sub_repo {
  local name=${1?'name arg required'}
  local sub_repo=${2?'sub_repo arg required'}
  shift 2

  _do_nx_enabled "${name}" || _do_print_warn "${name} repo is not an nx repo."

  local cmds=""
  # shellcheck disable=SC2124
  local repo_cmds="$@"

  for cmd in ${repo_cmds}; do
    cmds="${cmds} ${cmd}::${sub_repo}"
  done

  _do_log_debug 'nx' "cmds: $cmds"

  # shellcheck disable=SC2086
  _do_repo_plugin_cmd_add "${name}" 'nx' ${cmds}
}

function _do_nx_angular_app {
  local name=${1?'name arg required'}
  local sub_repo=${2?'sub_repo arg required'}
  shift 2

  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_nx_sub_repo "${name}" "${sub_repo}" ${DO_NX_ANGULAR_APP_CMDS} $@
}


function _do_nx_angular_lib {
  local name=${1?'name arg required'}
  local sub_repo=${2?'sub_repo arg required'}
  shift 2

  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_nx_sub_repo "${name}" "${sub_repo}" ${DO_NX_ANGULAR_LIB_CMDS} $@
}

function _do_nx_angular_publishable_lib {
  local name=${1?'name arg required'}
  local sub_repo=${2?'sub_repo arg required'}
  shift 2

  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_nx_sub_repo "${name}" "${sub_repo}" ${DO_NX_ANGULAR_PUBLISHABLE_LIB_CMDS} $@
}

function _do_nx_node_app {
  local name=${1?'name arg required'}
  local sub_repo=${2?'sub_repo arg required'}
  shift 2

  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_nx_sub_repo "${name}" "${sub_repo}" ${DO_NX_NODE_APP_CMDS} $@
}


function _do_nx_node_lib {
  local name=${1?'name arg required'}
  local sub_repo=${2?'sub_repo arg required'}
  shift 2

  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_nx_sub_repo "${name}" "${sub_repo}" ${DO_NX_NODE_LIB_CMDS} $@
}

function _do_nx_node_publishable_lib {
  local name=${1?'name arg required'}
  local sub_repo=${2?'sub_repo arg required'}
  shift 2

  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_nx_sub_repo "${name}" "${sub_repo}" ${DO_NX_NODE_PUBLISHABLE_LIB_CMDS} $@
}


# Determines if the specified repository has nx enabled.
#
function _do_nx_enabled() {
  local name=${1?'name arg required'}

  local dir
  dir=$(_do_repo_dir_get "${name}")

  # We do expects the repository to have nx.json file.
  [ -f "${dir}/firebase.json" ] || return 1
}
