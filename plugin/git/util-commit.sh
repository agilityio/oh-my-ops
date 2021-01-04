function _do_git_util_add() {
  local dir=${1?'dir arg required'}
  local msg=${2?'msg arg required'}

  _do_dir_exec "${dir}" "git add ." || return 1
}

function _do_git_util_commit() {
  local dir=${1?'dir arg required'}
  local msg=${2?'msg arg required'}

  _do_dir_exec "${dir}" "git add ." || return 1
  _do_dir_exec "${dir}" "git commit -m '${msg}'" || return 1
}
