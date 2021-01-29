_do_plugin "gitlabrunner"


function test_setup() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_gitlab 'fakerepo'
  _do_gitlabrunner 'fakerepo'

  do-fakerepo-gitlabrunner-stop &> /dev/null
  do-fakerepo-gitlab-stop &> /dev/null
}

function test_teardown() {
  do-fakerepo-gitlabrunner-stop &> /dev/null
  do-fakerepo-gitlab-stop &> /dev/null
}

function test_common_commands() {

  # Prints out help
  do-fakerepo-gitlabrunner-help || _do_assert_fail

  # Builds the gitlabrunner command
  # shellcheck disable=SC2086
  do-fakerepo-gitlabrunner-install || _do_assert_fail

  # Gets the status
  do-fakerepo-gitlabrunner-status || _do_assert_fail

  do-fakerepo-gitlab-stop
  do-fakerepo-gitlab-install || _do_assert_fail
  do-fakerepo-gitlab-start || _do_assert_fail

  # The run it.
  do-fakerepo-gitlabrunner-start || _do_assert_fail

  # Gets the status
  do-fakerepo-gitlabrunner-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-gitlabrunner-stop || _do_assert_fail
}

