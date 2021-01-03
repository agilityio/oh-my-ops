_do_plugin "rabbitmq"


function test_setup() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_rabbitmq 'fakerepo'

  do-fakerepo-rabbitmq-stop &> /dev/null
}

function test_teardown() {
  do-fakerepo-rabbitmq-stop &> /dev/null
}

function test_common_commands() {

  # Prints out help
  do-fakerepo-rabbitmq-help || _do_assert_fail

  # Builds the rabbitmq command
  # shellcheck disable=SC2086
  do-fakerepo-rabbitmq-install || _do_assert_fail

  # Gets the status
  do-fakerepo-rabbitmq-status || _do_assert_fail

  # The run it.
  do-fakerepo-rabbitmq-start || _do_assert_fail

  # Gets the status
  do-fakerepo-rabbitmq-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-rabbitmq-stop || _do_assert_fail
}

