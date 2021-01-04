_do_plugin "git"
_do_plugin "gitlab"

fake_repo_dir=""

function test_setup() {
  # Makes an empty git repository
  {
    fake_repo_dir=$(_do_dir_random_tmp_dir) &&
      _do_git_util_init "${fake_repo_dir}" &&
      cd "$fake_repo_dir"
  } || _do_assert_fail

  _do_repo "${fake_repo_dir}" 'fakerepo'
  _do_gitlab 'fakerepo'
}

function test_teardown() {
  # Removes the temp repository
  do-fakerepo-gitlab-stop &> /dev/null
  [ -z "$fake_repo_dir" ] || rm -rfd "$fake_repo_dir"
}

function test_full() {
  _do_git 'fakerepo'

  # Test all base commands
  do-fakerepo-git-help || _do_assert_fail
  do-fakerepo-git-status || _do_assert_fail

  touch "README.md"
  do-fakerepo-git-commit 'initial commit' || _do_assert_fail

  # Test branch
  do-fakerepo-git-create-branch 'develop' || _do_assert_fail
  do-fakerepo-git-create-branch 'qa' || _do_assert_fail
  do-fakerepo-git-checkout-branch 'develop' || _do_assert_fail
  do-fakerepo-git-remove-branch 'qa' || _do_assert_fail

  # Test stash
  echo "Hello" > 'README.md'
  do-fakerepo-git-create-stash  || _do_assert_fail
  do-fakerepo-git-apply-stash  || _do_assert_fail

  # Test tags
  do-fakerepo-git-create-tag 'v1.0'  || _do_assert_fail
  do-fakerepo-git-remove-tag 'v1.0'  || _do_assert_fail

  local url
  url=$(_do_gitlab_util_root_user_git_repo_url 'fakerepo' 'fakerepo') || _do_assert_fail
  _do_git_util_create_remote "${fake_repo_dir}" "gitlab" "${url}" || _do_assert_fail

  # Runs gitlab server
  do-fakerepo-gitlab-start || _do_assert_fail

  # Create a gitlab project named fake repo
  _do_gitlab_util_create_project 'fakerepo' 'fakerepo' || _do_assert_fail

  # Test pull & push
  do-fakerepo-git-commit 'initial commit' || _do_assert_fail
  do-fakerepo-git-push 'gitlab' || _do_assert_fail
  do-fakerepo-git-pull 'gitlab' || _do_assert_fail

  # Test sync
  echo "Hello World" > 'README.md'
  do-fakerepo-git-commit 'initial commit' || _do_assert_fail
  do-fakerepo-git-sync 'gitlab' || _do_assert_fail
}
