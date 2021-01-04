
function _do_git_util_create_stash() {
  local dir=${1?'dir arg required'}

  _do_dir_exec "${dir}" "git stash --quiet" 2> /dev/null || return 1
}

function _do_git_util_apply_stash() {
  local dir=${1?'dir arg required'}

  _do_dir_exec "${dir}" "git stash apply --quiet" || return 1
}
