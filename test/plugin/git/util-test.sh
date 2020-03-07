_do_plugin 'git'

fake_repo=""

function test_setup() {
  # Makes an empty git repository
  {
    fake_repo=$(_do_dir_random_tmp_dir) &&
    cd "$fake_repo" &&
    git init .
  } || _do_assert_fail
}

function test_teardown() {
  # Removes the temp repository
  [ -z "$fake_repo" ] || rm -rfd "$fake_repo"
}


function test_git_util_get_root() {
  local root

  {
    # Get root should be a success here
    cd "$fake_repo" &&
    root=$(_do_git_util_get_root) &&
    [ -n "$root" ] &&
    _do_dir_assert "$root/.git"

    # Cannot get git root, this should be error
    # because the .git folder has been removed already
    rm -rfd "$fake_repo/.git" &&
    root=$(_do_git_util_get_root)

  } || _do_assert_fail
}
