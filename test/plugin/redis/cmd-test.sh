_do_plugin "redis"


function test_common_commands() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_redis 'fakerepo'

  # Prints out help
  do-fakerepo-redis-help || _do_assert_fail

  # Builds the redis command
  # shellcheck disable=SC2086
  do-fakerepo-redis-install || _do_assert_fail

  # Gets the status
  do-fakerepo-redis-status || _do_assert_fail

  # The run it.
  do-fakerepo-redis-start || _do_assert_fail

  # Gets the status
  do-fakerepo-redis-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-redis-stop || _do_assert_fail
}

