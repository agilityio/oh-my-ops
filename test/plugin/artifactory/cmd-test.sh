_do_plugin "artifactory"

function test_setup() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_artifactory 'fakerepo'

  do-fakerepo-artifactory-stop &> /dev/null
}

function test_teardown() {
  do-fakerepo-artifactory-stop &> /dev/null
}

function test_common_commands() {

  # Prints out help
  do-fakerepo-artifactory-help || _do_assert_fail

  # Builds the artifactory command
  # shellcheck disable=SC2086
  do-fakerepo-artifactory-install || _do_assert_fail

  # Gets the status
  do-fakerepo-artifactory-status || _do_assert_fail

  # The run it.
  do-fakerepo-artifactory-start || _do_assert_fail

  # Gets the status
  do-fakerepo-artifactory-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-artifactory-stop || _do_assert_fail
}
