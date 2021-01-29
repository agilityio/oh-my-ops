_do_plugin "registry"

function test_setup() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_registry 'fakerepo'

  do-fakerepo-registry-stop &>/dev/null
}

function test_teardown() {
  do-fakerepo-registry-stop &>/dev/null
}

function test_common_commands() {

  # Prints out help
  do-fakerepo-registry-help || _do_assert_fail

  # Builds the registry command
  # shellcheck disable=SC2086
  do-fakerepo-registry-install || _do_assert_fail

  # Gets the status
  do-fakerepo-registry-status || _do_assert_fail

  # The run it.
  do-fakerepo-registry-start || _do_assert_fail

  sleep 3

  do-fakerepo-registry-login || _do_assert_fail

  do-fakerepo-registry-logout || _do_assert_fail

  # Gets the status
  do-fakerepo-registry-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-registry-stop || _do_assert_fail
}
