function _do_git_util_init() {
  local dir=${1?'dir arg required'}
  _do_dir_exec "${dir}" "git init ." || return 1
}
