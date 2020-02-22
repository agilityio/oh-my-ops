_do_plugin "mongo"


function test_build_start_stop() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_mongo 'fakerepo'

  # Builds the mongo command
  # shellcheck disable=SC2086
  do-fakerepo-mongo-install || _do_assert_fail

  # The run it.
  do-fakerepo-mongo-start || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-mongo-stop || _do_assert_fail
}

