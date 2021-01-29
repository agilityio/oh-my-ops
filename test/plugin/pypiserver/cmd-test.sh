_do_plugin "pypiserver"

function test_setup() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_pypiserver 'fakerepo'
}

function test_teardown() {
  do-fakerepo-pypiserver-stop &> /dev/null
}

function test_common_commands() {

  # Prints out help
  do-fakerepo-pypiserver-help || _do_assert_fail

  # Builds the pypiserver command
  # shellcheck disable=SC2086
  do-fakerepo-pypiserver-install || _do_assert_fail

  # Gets the status
  do-fakerepo-pypiserver-status || _do_assert_fail

  # The run it.
  do-fakerepo-pypiserver-start || _do_assert_fail

  # Gets the status
  do-fakerepo-pypiserver-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-pypiserver-stop || _do_assert_fail
}

