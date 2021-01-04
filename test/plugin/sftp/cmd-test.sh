_do_plugin "sftp"


function test_setup() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_sftp 'fakerepo'

  do-fakerepo-sftp-stop &> /dev/null
}

function test_teardown() {
  do-fakerepo-sftp-stop &> /dev/null
}

function test_common_commands() {

  # Prints out help
  do-fakerepo-sftp-help || _do_assert_fail

  # Builds the sftp command
  # shellcheck disable=SC2086
  do-fakerepo-sftp-install || _do_assert_fail

  # Gets the status
  do-fakerepo-sftp-status || _do_assert_fail

  # The run it.
  do-fakerepo-sftp-start || _do_assert_fail

  # Gets the status
  do-fakerepo-sftp-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-sftp-stop || _do_assert_fail
}

