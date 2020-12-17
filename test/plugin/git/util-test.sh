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
    rm -rfd "$fake_repo/.git" &> /dev/null &&
      root=$(_do_git_util_get_root)

  } || _do_assert_fail
}

# TODO: Test this case
#function test_git_repo_up_to_date() {
#  ! _do_git_util_is_up_to_date "${fake_repo}" || _do_assert_fail
#}

function test_git_repo_is_is_dirty() {
  ! _do_git_util_is_dirty "${fake_repo}" || _do_assert_fail

  cd "$fake_repo" && touch "README.md"
  _do_git_util_is_dirty "${fake_repo}" || _do_assert_fail

  git add .
  _do_git_util_is_dirty "${fake_repo}" || _do_assert_fail

  git commit -m "initial commit"
  ! _do_git_util_is_dirty "${fake_repo}" || _do_assert_fail
}
