_do_plugin "mongo"


function test_setup() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_mongo 'fakerepo'
  do-fakerepo-mongo-stop &> /dev/null
}

function test_teardown() {
  do-fakerepo-mongo-stop &> /dev/null
}

function test_common_commands() {

  # Prints out help
  do-fakerepo-mongo-help || _do_assert_fail

  # Builds the mongo command
  # shellcheck disable=SC2086
  do-fakerepo-mongo-install || _do_assert_fail

  # Gets the status
  do-fakerepo-mongo-status || _do_assert_fail

  # The run it.
  do-fakerepo-mongo-start || _do_assert_fail

  # Gets the status
  do-fakerepo-mongo-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-mongo-stop || _do_assert_fail
}

