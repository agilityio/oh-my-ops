_do_plugin "jenkins"


function test_setup() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_jenkins 'fakerepo'

  do-fakerepo-jenkins-stop &> /dev/null
}

function test_teardown() {
  do-fakerepo-jenkins-stop &> /dev/null
}

function test_common_commands() {

  # Prints out help
  do-fakerepo-jenkins-help || _do_assert_fail

  # Builds the jenkins command
  # shellcheck disable=SC2086
  do-fakerepo-jenkins-install || _do_assert_fail

  # Gets the status
  do-fakerepo-jenkins-status || _do_assert_fail

  # The run it.
  do-fakerepo-jenkins-start || _do_assert_fail

  # Gets the status
  do-fakerepo-jenkins-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-jenkins-stop || _do_assert_fail
}

