function _do_git_hook_before_repo_dir_add() {
  local dir=${1?'dir arg required'}
  local repo=${1?'repo arg required'}

  _do_log_debug 'git' "_do_git_hook_before_repo_dir_add ${dir} ${repo}"

  _do_dir_push "${dir}"

  local git_dir
  if git_dir=$(git rev-parse --show-toplevel) 2>/dev/null; then
    if ! _do_repo_dir_exists "${dir}"; then
      _do_git_repo_add "${git_dir}"
    fi
  fi

  _do_dir_pop
}
