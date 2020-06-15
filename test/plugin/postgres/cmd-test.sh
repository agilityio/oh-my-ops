_do_plugin "postgres"


function test_common_commands() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_postgres 'fakerepo'

  # Prints out help
  do-fakerepo-postgres-help || _do_assert_fail

  # Builds the postgres command
  # shellcheck disable=SC2086
  do-fakerepo-postgres-install || _do_assert_fail

  # Gets the status
  do-fakerepo-postgres-status || _do_assert_fail

  # The run it.
  do-fakerepo-postgres-start || _do_assert_fail

  # Gets the status
  do-fakerepo-postgres-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-postgres-stop || _do_assert_fail
}

