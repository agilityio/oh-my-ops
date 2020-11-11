# Enables firebase commands for the specified repository.
# Arguments:
#   1. name: The repository name.
#
function _do_firebase() {
  local name=${1?'name arg required'}
  shift 1

  _do_firebase_enabled "${name}" || _do_print_warn "${name} repo is not an firebase repo."

  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_repo_plugin_cmd_add "${name}" 'firebase' ${DO_FIREBASE_CMDS} $@
}

function _do_firebase_sub_repo() {
  local name=${1?'name arg required'}
  local sub_repo=${2?'sub_repo arg required'}
  shift 2

  _do_firebase_enabled "${name}" || _do_print_warn "${name} repo is not an firebase repo."

  local cmds=""
  # shellcheck disable=SC2124
  local repo_cmds="$@"

  for cmd in ${repo_cmds}; do
    cmds="${cmds} ${cmd}__${sub_repo}"
  done

  _do_log_debug 'firebase' "cmds: $cmds"

  # shellcheck disable=SC2086
  _do_repo_plugin_cmd_add "${name}" 'firebase' ${cmds}
}

function _do_firebase_hosting() {
  local name=${1?'name arg required'}
  local sub_repo=${2?'sub_repo arg required'}
  shift 2


  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_firebase_sub_repo "${name}" "${sub_repo}" ${DO_FIREBASE_HOSTING_SUB_CMDS} $@
  _do_repo_plugin_cmd_add "${name}" 'firebase' ${DO_FIREBASE_HOSTING_CMDS}
}

function _do_firebase_firestore() {
  local name=${1?'name arg required'}
  shift 1

  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_repo_plugin_cmd_add "${name}" 'firebase' ${DO_FIREBASE_FIRESTORE_CMDS}
}

function _do_firebase_function() {
  local name=${1?'name arg required'}
  shift 1

  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_repo_plugin_cmd_add "${name}" 'firebase' ${DO_FIREBASE_FUNCTION_CMDS}
}

function _do_firebase_storage() {
  local name=${1?'name arg required'}
  shift 1

  # shellcheck disable=SC2086
  # shellcheck disable=SC2068
  _do_repo_plugin_cmd_add "${name}" 'firebase' ${DO_FIREBASE_STORAGE_CMDS}
}


# Determines if the specified repository has firebase enabled.
#
function _do_firebase_enabled() {
  local name=${1?'name arg required'}

  local dir
  dir=$(_do_repo_dir_get "${name}")

  # We do expects the repository to have firebase.json file.
  [ -f "${dir}/firebase.json" ] || return 1
}
