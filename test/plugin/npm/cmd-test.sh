_do_plugin "npm"


function test_init() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  {
    cd "$dir" &&
    echo '
{
  "name": "fakerepo",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "test": "echo just a fake test run.",
    "clean": "echo just a fake clean"
  }
}
' > "${dir}/package.json"
  } || _do_assert_fail

  _do_npm 'fakerepo' 'clean' 'test'

  # Test all base commands
  do-fakerepo-npm-help || _do_assert_fail
  do-fakerepo-npm-install || _do_assert_fail
  do-fakerepo-npm-clean || _do_assert_fail
  do-fakerepo-npm-test || _do_assert_fail
}
