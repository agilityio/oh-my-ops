_do_plugin "full"
_do_plugin "mongo"
_do_plugin "git"
_do_plugin "npm"
_do_plugin "flutter"

dir=""

function assert_base_cmds() {
  # Prints out help
  do-fakerepo-full-help || _do_assert_fail

  # Prints out all status
  do-fakerepo-full-status || _do_assert_fail
}

function test_setup() {
  dir=$(_do_dir_random_tmp_dir)
  cd "$dir" && git init . && npm init -y

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_git 'fakerepo' || _do_assert_fail
  _do_mongo 'fakerepo' || _do_assert_fail
}

function test_full() {
  _do_full 'fakerepo' || _do_assert_fail
  _do_npm 'fakerepo' || _do_assert_fail
  assert_base_cmds
}

function test_full_web() {
  _do_full_web 'fakerepo' || _do_assert_fail
  _do_npm_angular 'fakerepo' || _do_assert_fail
  assert_base_cmds
}

function test_full_mobile() {
  _do_full_mobile 'fakerepo' || _do_assert_fail
  _do_flutter_mobile 'fakerepo' || _do_assert_fail

  assert_base_cmds
}
