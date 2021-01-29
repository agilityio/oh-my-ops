_do_plugin 'git'

fake_repo_dir=""

function test_setup() {
  # Makes an empty git repository
  {
    fake_repo_dir=$(_do_dir_random_tmp_dir) &&
      _do_git_util_init "${fake_repo_dir}" &&
      cd "$fake_repo_dir"
  } || _do_assert_fail

}

function test_teardown() {
  # Removes the temp repository
  [ -z "$fake_repo_dir" ] || rm -rfd "$fake_repo_dir"
}

function test_git_util_get_root() {
  local root

  {
    # Get root should be a success here
    cd "$fake_repo_dir" &&
      root=$(_do_git_util_get_root_dir) &&
      [ -n "$root" ] &&
      _do_dir_assert "$root/.git"

    # Cannot get git root, this should be error
    # because the .git folder has been removed already
    rm -rfd "$fake_repo_dir/.git" &> /dev/null &&
      root=$(_do_git_util_get_root_dir)

  } || _do_assert_fail
}

# TODO: Test this case
#function test_git_repo_up_to_date() {
#  ! _do_git_util_is_up_to_date "${fake_repo_dir}" || _do_assert_fail
#}


function test_git_util_is_is_dirty() {
  ! _do_git_util_is_dirty "${fake_repo_dir}" || _do_assert_fail

  touch "README.md"
  _do_git_util_is_dirty "${fake_repo_dir}" || _do_assert_fail

  git add .
  _do_git_util_is_dirty "${fake_repo_dir}" || _do_assert_fail

  git commit -m "initial commit"
  ! _do_git_util_is_dirty "${fake_repo_dir}" || _do_assert_fail
}


function test_git_util_commit() {
  echo "Hello" > 'README.md'
  _do_git_util_commit "${fake_repo_dir}" 'initial commit' || _do_assert_fail
  ! _do_git_util_is_dirty "${fake_repo_dir}" || _do_assert_fail
}

function test_git_util_stash() {
  touch 'README.md'
  _do_git_util_commit "${fake_repo_dir}" 'initial commit' || _do_assert_fail

  echo "Hello" > 'README.md'
  _do_git_util_is_dirty "${fake_repo_dir}" || _do_assert_fail

  _do_git_util_create_stash "${fake_repo_dir}"  || _do_assert_fail
  ! _do_git_util_is_dirty "${fake_repo_dir}" || _do_assert_fail

  _do_git_util_apply_stash "${fake_repo_dir}" || _do_assert_fail
  _do_git_util_is_dirty "${fake_repo_dir}" || _do_assert_fail
}

function test_git_util_tag() {
  touch 'README.md'
  _do_git_util_commit "${fake_repo_dir}" 'initial commit' || _do_assert_fail

  ! _do_git_util_tag_exists "${fake_repo_dir}" "v1" || _do_assert_fail
  _do_git_util_create_tag "${fake_repo_dir}" "v1" || _do_assert_fail
  _do_git_util_tag_exists "${fake_repo_dir}" "v1" || _do_assert_fail

  _do_git_util_create_tag "${fake_repo_dir}" "v2" || _do_assert_fail
  _do_git_util_list_tag_names "${fake_repo_dir}" || _do_assert_fail

  _do_git_util_remove_tag "${fake_repo_dir}" "v1" || _do_assert_fail
  ! _do_git_util_tag_exists "${fake_repo_dir}" "v1" || _do_assert_fail
}

function test_git_util_branch() {

  # Commit code and the current branch is master
  touch 'README.md'
  _do_git_util_commit "${fake_repo_dir}" 'initial commit' || _do_assert_fail
  [[ "master" == "$(_do_git_util_get_current_branch "${fake_repo_dir}")" ]] || _do_assert_fail
  _do_git_util_is_current_branch "${fake_repo_dir}" "master" || _do_assert_fail

  _do_git_util_list_branch_names "${fake_repo_dir}" || _do_assert_fail

  # master branch exists, and develop is not yet.
  _do_git_util_branch_exists "${fake_repo_dir}" 'master' || _do_assert_fail
  ! _do_git_util_branch_exists "${fake_repo_dir}" 'develop' || _do_assert_fail

  # Creates a new branch and the current branch is develop
  _do_git_util_create_branch "${fake_repo_dir}" 'develop' || _do_assert_fail
  _do_git_util_branch_exists "${fake_repo_dir}" 'develop' || _do_assert_fail
  _do_git_util_is_current_branch "${fake_repo_dir}" "develop" || _do_assert_fail

  # Go back to master branch
  _do_git_util_checkout_branch "${fake_repo_dir}" 'master' || _do_assert_fail
  _do_git_util_is_current_branch "${fake_repo_dir}" "master" || _do_assert_fail

  # Checkout master if not current, should work
  _do_git_util_checkout_branch_if_not_current "${fake_repo_dir}" 'master' || _do_assert_fail
  _do_git_util_is_current_branch "${fake_repo_dir}" "master" || _do_assert_fail

  # Checkout develop if not current, should work
  _do_git_util_checkout_branch_if_not_current "${fake_repo_dir}" 'develop' || _do_assert_fail
  _do_git_util_is_current_branch "${fake_repo_dir}" "develop" || _do_assert_fail

  # Delete the master branch
  _do_git_util_remove_branch "${fake_repo_dir}" "master" || _do_assert_fail
  ! _do_git_util_branch_exists "${fake_repo_dir}" 'master' || _do_assert_fail

  # Branch from develop back to master
  _do_git_util_create_branch_if_missing "${fake_repo_dir}" "master" || _do_assert_fail
  _do_git_util_branch_exists "${fake_repo_dir}" 'master' || _do_assert_fail

  # Check out from master back to develop
  _do_git_util_create_branch_if_missing "${fake_repo_dir}" "develop" || _do_assert_fail
}

