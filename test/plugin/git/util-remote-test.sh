_do_plugin 'git'
_do_plugin 'gitlab'

fake_repo_dir=""

function test_setup() {
  # Makes an empty git repository
  {
    fake_repo_dir=$(_do_dir_random_tmp_dir) &&
      _do_git_util_init "${fake_repo_dir}" &&
      cd "$fake_repo_dir"
  } || _do_assert_fail

  _do_repo_dir_add "${fake_repo_dir}" "fakerepo"
  _do_gitlab 'fakerepo'

  do-fakerepo-gitlab-stop &> /dev/null
}

function test_teardown() {
  # Removes the temp repository
  do-fakerepo-gitlab-stop &> /dev/null
  [ -z "$fake_repo_dir" ] || rm -rfd "$fake_repo_dir"
}


function test_git_util_commit() {
  echo "Hello" > 'README.md'
  _do_git_util_commit "${fake_repo_dir}" 'initial commit' || _do_assert_fail
  ! _do_git_util_is_dirty "${fake_repo_dir}" || _do_assert_fail

  ! _do_git_util_remote_exists "${fake_repo_dir}" "gitlab" || _do_assert_fail

  local url
  url=$(_do_gitlab_util_root_user_git_repo_url 'fakerepo' 'fakerepo') || _do_assert_fail

  # Creates gitlab remote
  _do_git_util_create_remote "${fake_repo_dir}" "gitlab" "${url}" || _do_assert_fail
  _do_git_util_remote_exists "${fake_repo_dir}" "gitlab" || _do_assert_fail

  # Makes sure the url is stored correctly
  _do_assert_eq "${url}" "$(_do_git_util_get_remote_url "${fake_repo_dir}" "gitlab")"

  # Creates again, should be ignored
  _do_git_util_create_remote_if_missing "${fake_repo_dir}" "gitlab" "${url}" || _do_assert_fail

  # Creates another, should be executed
  _do_git_util_create_remote_if_missing "${fake_repo_dir}" "another" "${url}" || _do_assert_fail
  _do_git_util_remote_exists "${fake_repo_dir}" "another" || _do_assert_fail

  _do_git_assert_remote_list_size "${fake_repo_dir}" "2"

  _do_git_util_remove_remote "${fake_repo_dir}" "another"
  ! _do_git_util_remote_exists "${fake_repo_dir}" "another" || _do_assert_fail
  _do_git_assert_remote_list_size "${fake_repo_dir}" "1"

  # Runs gitlab server
  do-fakerepo-gitlab-start || _do_assert_fail

  # Create a gitlab project named fake repo
  _do_gitlab_util_create_project 'fakerepo' 'fakerepo' || _do_assert_fail

  # Push code
  _do_git_util_push "${fake_repo_dir}" 'gitlab' || _do_assert_fail

  # Pull code
  _do_git_util_pull "${fake_repo_dir}" 'gitlab' || _do_assert_fail
}
