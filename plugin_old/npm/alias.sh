
# Register npm alias to run on a repository
#
function _do_npm_repo_alias {
  local dir=${1?'dir arg required'}

  local repo=$(_do_string_to_dash $dir)
  shift 1

  for cmd in "clean" "start" "install" "watch" "test" "build" "lint" "link" "unlink" "publish" "unpublish"; do
    alias "do-${repo}-${cmd}"="_do_npm_run ${dir} ${repo} ${cmd}"
  done
}
