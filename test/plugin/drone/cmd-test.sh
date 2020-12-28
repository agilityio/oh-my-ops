_do_plugin "drone"


function test_common_commands() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_gitlab 'fakerepo'
  _do_drone 'fakerepo'

  # Needs to starts gitlab first.
  do-fakerepo-gitlab-stop
  do-fakerepo-gitlab-install || _do_assert_fail
  do-fakerepo-gitlab-start || _do_assert_fail

  # Stop drone server, just in case
  do-fakerepo-drone-stop

  do-fakerepo-drone-help || _do_assert_fail

  # Builds the drone command
  # shellcheck disable=SC2086
  do-fakerepo-drone-install || _do_assert_fail

  # Gets the status
  do-fakerepo-drone-status || _do_assert_fail

  # The run it.
  do-fakerepo-drone-start || _do_assert_fail

  # Gets the status
  do-fakerepo-drone-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-drone-stop || _do_assert_fail
}

