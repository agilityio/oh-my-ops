_do_plugin "gitlab"


function test_common_commands() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_gitlab 'fakerepo'

  # Prints out help
  do-fakerepo-gitlab-help || _do_assert_fail

  # Builds the gitlab command
  # shellcheck disable=SC2086
  do-fakerepo-gitlab-install || _do_assert_fail

  # Gets the status
  do-fakerepo-gitlab-status || _do_assert_fail

  # The run it.
  do-fakerepo-gitlab-start || _do_assert_fail

  # Gets the status
  do-fakerepo-gitlab-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-gitlab-stop || _do_assert_fail
}

