_do_plugin "jupyter"


function test_setup() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_jupyter 'fakerepo'

  do-fakerepo-jupyter-stop &> /dev/null
}

function test_teardown() {
  do-fakerepo-jupyter-stop &> /dev/null
}

function test_common_commands() {

  # Prints out help
  do-fakerepo-jupyter-help || _do_assert_fail

  # Builds the jupyter command
  # shellcheck disable=SC2086
  do-fakerepo-jupyter-install || _do_assert_fail

  # Gets the status
  do-fakerepo-jupyter-status || _do_assert_fail

  # The run it.
  do-fakerepo-jupyter-start || _do_assert_fail

  # Gets the status
  do-fakerepo-jupyter-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-jupyter-stop || _do_assert_fail
}

