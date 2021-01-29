function _do_git_util_get_current_branch() {
  local dir=${1?'dir arg required'}
  _do_dir_exec "${dir}" "git status | grep 'On branch ' | awk {'print \$3'}" || return 1
}

function _do_git_util_is_current_branch() {
  local dir=${1?'dir arg required'}
  local branch=${2?'branch arg required'}

  [[ "$(_do_git_util_get_current_branch "${dir}")" == "${branch}" ]] ||
    return 1
}

function _do_git_util_checkout_branch() {
  local dir=${1?'dir arg required'}
  local branch=${2?'branch arg required'}
  _do_dir_exec "${dir}" "git checkout ${branch}" || return 1
}

function _do_git_util_checkout_branch_if_not_current() {
  local dir=${1?'dir arg required'}
  local branch=${2?'branch arg required'}

  _do_git_util_is_current_branch "${dir}" "${branch}" ||
    _do_git_util_checkout_branch "${dir}" "${branch}" ||
    return 1
}

function _do_git_util_branch_exists() {
  local dir=${1?'dir arg required'}
  local branch=${2?'branch arg required'}

  _do_git_util_list_branch_names "${dir}" | grep -e "^${branch}$" &>/dev/null ||
    return 1
}

function _do_git_util_create_branch() {
  local dir=${1?'dir arg required'}
  local branch=${2?'branch arg required'}

  _do_dir_exec "${dir}" "git checkout -b ${branch}" || return 1
}

function _do_git_util_create_branch_if_missing() {
  local dir=${1?'dir arg required'}
  local branch=${2?'branch arg required'}

  if _do_git_util_branch_exists "${dir}" "${branch}"; then
    _do_git_util_checkout_branch "${dir}" "${branch}" || return 1
  else
    _do_git_util_create_branch "${dir}" "${branch}"  || return 1
  fi
}

function _do_git_util_remove_branch() {
  local dir=${1?'dir arg required'}
  local branch=${2?'branch arg required'}

  _do_dir_exec "${dir}" "git branch -d ${branch}" || return 1
}

function _do_git_util_list_branch_names() {
  local dir=${1?'dir arg required'}

  _do_dir_exec "${dir}" "git for-each-ref refs/heads | cut -d/ -f3-" || return 1
}
