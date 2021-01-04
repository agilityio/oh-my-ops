function _do_git_util_get_remote_url() {
  local dir=${1?'dir arg required'}
  local remote=${2?'remote arg required'}

  _do_dir_exec "${dir}" git remote get-url "${remote}" 2>/dev/null || return 1
}

function _do_git_util_remote_exists() {
  local dir=${1?'dir arg required'}
  local remote=${2?'remote arg required'}
  _do_git_util_get_remote_url "${dir}" "${remote}" &>/dev/null || return 1
}

function _do_git_util_create_remote() {
  local dir=${1?'dir arg required'}
  local remote=${2?'remote arg required'}
  local url=${3?'url arg required'}

  _do_dir_exec "${dir}" "git remote add ${remote} '${url}'" 2>/dev/null || return 1
}

function _do_git_util_create_remote_if_missing() {
  local dir=${1?'dir arg required'}
  local remote=${2?'remote arg required'}
  local url=${3?'url arg required'}

  _do_git_util_remote_exists "${dir}" "${remote}" ||
    _do_git_util_create_remote "${dir}" "${remote}" "${url}" ||
    return 1
}

function _do_git_util_remove_remote() {
  local dir=${1?'dir arg required'}
  local remote=${2?'remote arg required'}

  _do_dir_exec "${dir}" git remote rm "${remote}" || return 1
}

function _do_git_util_get_list_remote_names() {
  local dir=${1?'dir arg required'}

  _do_dir_exec "${dir}" git remote || return 1
}

function _do_git_util_get_remote_list_size() {
  local dir=${1?'dir arg required'}
  local remotes
  readarray -t remotes <<< "$(_do_git_util_get_list_remote_names "${dir}")" || _do_assert_fail
  echo "${#remotes[@]}"
}

function _do_git_assert_remote_list_size() {
  local dir=${1?'dir arg required'}
  local size=${2?'size arg required'}
  _do_assert_eq "${size}" "$(_do_git_util_get_remote_list_size "${dir}")"
}

function _do_git_util_push() {
  local dir=${1?'dir arg required'}
  local remote=${2?'remote arg required'}
  local branch=${3:-"$(_do_git_util_get_current_branch "${dir}")"}

  _do_dir_exec "${dir}" "git push '${remote}' '${branch}'" 2>/dev/null || return 1
}

function _do_git_util_pull() {
  local dir=${1?'dir arg required'}
  local remote=${2?'remote arg required'}
  local branch=${3:-"$(_do_git_util_get_current_branch "${dir}")"}

  _do_dir_exec "${dir}" "git pull '${remote}' '${branch}'" 2>/dev/null || return 1
}

function _do_git_util_get_fetch_remote() {
  local dir=${1?'dir arg required'}
  local remote=${2?'remote arg required'}

  _do_dir_exec "${dir}" "git fetch ${remote}" 2>/dev/null || return 1
}

function _do_git_util_get_fetch_all_remotes() {
  local dir=${1?'dir arg required'}
  _do_dir_exec "${dir}" "git fetch --all" 2>/dev/null || return 1
}
