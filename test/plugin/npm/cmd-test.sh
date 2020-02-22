_do_plugin "npm"


function test_build_start_stop() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_npm 'fakerepo'

  # Prints out help
  do-fakerepo-npm-help || _do_assert_fail
}
