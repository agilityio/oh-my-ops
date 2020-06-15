_do_plugin "neo4j"


function test_common_commands() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_neo4j 'fakerepo'

  # Prints out help
  do-fakerepo-neo4j-help || _do_assert_fail

  # Builds the neo4j command
  # shellcheck disable=SC2086
  do-fakerepo-neo4j-install || _do_assert_fail

  # Gets the status
  do-fakerepo-neo4j-status || _do_assert_fail

  # The run it.
  do-fakerepo-neo4j-start || _do_assert_fail

  # Gets the status
  do-fakerepo-neo4j-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-neo4j-stop || _do_assert_fail
}

