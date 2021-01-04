# Runs a git command at a specified directory.
#
# Arguments:
#   1. dir: The directory to run the command for.
#   2. cmd: The command to run.
#       * status: Gets git status.
#
function _do_git_repo_cmd() {
  local dir=${1?'dir arg required'}
  local cmd=${3?'cmd arg required'}
  shift 3

  # shellcheck disable=SC2068
  case "${cmd}" in
    status)
      _do_git_util_status "${dir}" || return 1
      ;;
    add)
      local msg=${1?'message is required'}
      _do_git_util_add "${dir}" "${msg}" || return 1
      ;;
    commit)
      local msg=${1?'message is required'}
      _do_git_util_commit "${dir}" "${msg}" || return 1
      ;;
    push)
      local remote=${1?'remote is required'}
      _do_git_util_push "${dir}" "${remote}" || return 1
      ;;
    pull)
      local remote=${1?'remote is required'}
      _do_git_util_pull "${dir}" "${remote}" || return 1
      ;;
    sync)
      local remote=${1?'remote is required'}
      _do_git_util_sync "${dir}" "${remote}" || return 1
      ;;
    create-stash)
      _do_git_util_create_stash "${dir}" || return 1
      ;;
    apply-stash)
      _do_git_util_apply_stash "${dir}" || return 1
      ;;
    checkout-branch)
      local name=${1?'branch name is required'}
      _do_git_util_checkout_branch_if_not_current "${dir}" "${name}" || return 1
      ;;
    create-branch)
      local name=${1?'branch name is required'}
      _do_git_util_create_branch_if_missing "${dir}" "${name}" || return 1
      ;;
    remove-branch)
      local name=${1?'branch name is required'}
      _do_git_util_remove_branch "${dir}" "${name}" || return 1
      ;;
    create-tag)
      local name=${1?'tag name is required'}
      _do_git_util_create_tag "${dir}" "${name}" || return 1
      ;;
    remove-tag)
      local name=${1?'tag name is required'}
      _do_git_util_remove_tag "${dir}" "${name}" || return 1
      ;;

  esac
}
