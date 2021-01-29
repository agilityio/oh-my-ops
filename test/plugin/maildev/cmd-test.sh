_do_plugin "maildev"


function test_setup() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_maildev 'fakerepo'

  do-fakerepo-maildev-stop &> /dev/null
}

function test_teardown() {
  do-fakerepo-maildev-stop &> /dev/null
}

function test_common_commands() {

  # Prints out help
  do-fakerepo-maildev-help || _do_assert_fail

  # Builds the maildev command
  # shellcheck disable=SC2086
  do-fakerepo-maildev-install || _do_assert_fail

  # Gets the status
  do-fakerepo-maildev-status || _do_assert_fail

  # The run it.
  do-fakerepo-maildev-start || _do_assert_fail

  # Gets the status
  do-fakerepo-maildev-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-maildev-stop || _do_assert_fail
}

