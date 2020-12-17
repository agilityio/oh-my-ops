_do_plugin "nx"

function test_repo() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  {
    # Creates an empty nx workspace. If anything fails,
    # please try "npx create-nx-workspace@latest --help" to figure out.
    cd "$dir" &&
      npx create-nx-workspace@latest fakerepo -q --preset=empty --cli=angular --nx-cloud=false
  } || _do_assert_fail

  _do_repo_dir_add "${dir}/fakerepo" "fakerepo"
  _do_nx 'fakerepo'

  # Test all base commands
  do-fakerepo-nx-help || _do_assert_fail
  do-fakerepo-nx-affected-test || _do_assert_fail
  do-fakerepo-nx-affected-lint || _do_assert_fail
  do-fakerepo-nx-affected-build || _do_assert_fail
}

function skip_test_angular_app() {

  local dir
  dir=$(_do_dir_random_tmp_dir)

  {
    # Creates an nx workspace with an angular application..
    # please try "npx create-nx-workspace@latest --help" to figure out.
    cd "$dir" &&
      npx create-nx-workspace@latest fakerepo -q --preset=angular \
        --cli=angular --nx-cloud=false --style=scss --appName=demo --linter=tslint
  } || _do_assert_fail

  _do_repo_dir_add "${dir}/fakerepo" "fakerepo"
  _do_nx_angular_app 'fakerepo' 'demo'

  # Test all base commands
  do-fakerepo-nx-build-demo || _do_assert_fail
  do-fakerepo-nx-lint-demo || _do_assert_fail
  do-fakerepo-nx-test-demo || _do_assert_fail
}
