 _do_git_util_tag_exists() {
  local dir=${1?'dir arg required'}
  local tag=${2?'tag arg required'}

  _do_git_util_list_tag_names "${dir}" | grep -e "^${tag}$" &>/dev/null ||
    return 1
}

function _do_git_util_create_tag() {
  local dir=${1?'dir arg required'}
  local tag=${2?'tag arg required'}

  _do_dir_exec "${dir}" "git tag ${tag}" || return 1
}

function _do_git_util_create_tag_if_missing() {
  local dir=${1?'dir arg required'}
  local tag=${2?'tag arg required'}

  _do_git_util_tag_exists "${dir}" "${tag}" ||
    _do_git_util_create_tag "${dir}" "${tag}"  ||
    return 1
}

function _do_git_util_remove_tag() {
  local dir=${1?'dir arg required'}
  local tag=${2?'tag arg required'}

  _do_dir_exec "${dir}" "git tag -d ${tag}" || return 1
}

function _do_git_util_list_tag_names() {
  local dir=${1?'dir arg required'}

  _do_dir_exec "${dir}" "git tag --list" || return 1
}
