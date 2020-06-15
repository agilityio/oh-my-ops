_do_plugin "keycloak"


function test_common_commands() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_keycloak 'fakerepo'

  # Prints out help
  do-fakerepo-keycloak-help || _do_assert_fail

  # Builds the keycloak command
  # shellcheck disable=SC2086
  do-fakerepo-keycloak-install || _do_assert_fail

  # Gets the status
  do-fakerepo-keycloak-status || _do_assert_fail

  # The run it.
  do-fakerepo-keycloak-start || _do_assert_fail

  # Gets the status
  do-fakerepo-keycloak-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-keycloak-stop || _do_assert_fail
}

