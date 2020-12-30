_do_plugin "registry"


function test_common_commands() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_registry 'fakerepo'

  # Prints out help
  do-fakerepo-registry-help || _do_assert_fail

  # Builds the registry command
  # shellcheck disable=SC2086
  do-fakerepo-registry-install || _do_assert_fail

  # Gets the status
  do-fakerepo-registry-status || _do_assert_fail

  # The run it.
  do-fakerepo-registry-start || _do_assert_fail

  # Gets the status
  do-fakerepo-registry-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-registry-stop || _do_assert_fail
}

