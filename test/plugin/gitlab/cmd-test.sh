_do_plugin "gitlab"

function test_setup() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  _do_gitlab 'fakerepo'

  do-fakerepo-gitlab-stop &> /dev/null
}

function test_teardown() {
  do-fakerepo-gitlab-stop &> /dev/null
}

function test_common_commands() {

  # Prints out help
  do-fakerepo-gitlab-help || _do_assert_fail

  # Builds the gitlab command
  # shellcheck disable=SC2086
  do-fakerepo-gitlab-install || _do_assert_fail

  # Gets the status
  do-fakerepo-gitlab-status || _do_assert_fail

  # The run it.
  do-fakerepo-gitlab-start || _do_assert_fail

  # Waits the repo to start, this should work
  do-fakerepo-gitlab-wait || _do_assert_fail

  # Test the api here instead of a different test because starts
  # a gitlab server is quite slow.
  _do_assert_eq "http://do:8280" "$(_do_gitlab_util_app_url 'fakerepo')"
  _do_assert_eq "http://do:8280/api/v4" "$(_do_gitlab_util_api_url 'fakerepo')"
  _do_assert_eq "http://do:8280/api/v4" "$(_do_gitlab_util_api_url 'fakerepo')"
  _do_assert "$(_do_gitlab_util_authenticate 'fakerepo')"
  _do_gitlab_util_create_project 'fakerepo' 'hello-world' || _do_assert_fail
  _do_gitlab_util_project_exists 'fakerepo' 'hello-world' || _do_assert_fail

  _do_gitlab_util_create_project_if_missing 'fakerepo' 'hello-world-2' || _do_assert_fail
  _do_gitlab_util_project_exists 'fakerepo' 'hello-world-2' || _do_assert_fail
  _do_gitlab_util_create_project_if_missing 'fakerepo' 'hello-world-2' || _do_assert_fail

  _do_gitlab_util_psql_create_application 'fakerepo' \
    "Drone" \
    "7bd7074378956edce103bfb6a110d658a6f5eb9f8049512b46a570ea6f6c1a63" \
    "9ae609b5ab7babbe8c70befdd3c5d5f8a8cec8ff3fa70429661f3c512308e919" \
    "http://do:8480/login" \
    'api read_user openid' || _do_assert_fail

  # Gets the status
  do-fakerepo-gitlab-status || _do_assert_fail

  # Then should be ok to kill it
  # shellcheck disable=SC2086
  do-fakerepo-gitlab-stop || _do_assert_fail
}
