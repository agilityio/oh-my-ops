source "$(_do_src_dir)/util.sh"

function test_setup() {
  # FIXME: This need project input
  _do_repo_clone "${fake_repo}"

  _do_dir_assert "${proj_dir}/${fake_repo}"

  # Makes sure git repository is enabled
  _do_git_repo_enabled "${proj_dir}" "${fake_repo}" || _do_assert_fail
}

function test_clone() {

  # Display helps
  _do_git_repo_help "${proj_dir}" "${fake_repo}" || _do_assert_fail

  # After generated , the files not yet been add.
  # The repository should be cleaned.
  ! _do_git_repo_is_dirty "${proj_dir}" "${fake_repo}" || _do_assert_fail

  # Just modify a file.
  echo "Hello World" >>"$proj_dir/$fake_repo/README.md"

  # Add the files to git, it should be dirty now.
  _do_git_repo_add "${proj_dir}" "${fake_repo}" || _do_assert_fail

  # Display git status should work.
  _do_git_repo_status "${proj_dir}" "${fake_repo}" || _do_assert_fail

  # Makes sure the git repository is dirty after adding the file
  _do_git_repo_is_dirty "${proj_dir}" "${fake_repo}" || _do_assert_fail

  # Makes sure the git repository is dirty after adding the file
  _do_git_repo_commit "${proj_dir}" "${fake_repo}" "a sample message" || _do_assert_fail

  # After commit the repository should be clean again
  ! _do_git_repo_is_dirty "${proj_dir}" "${fake_repo}" || _do_assert_fail

  local remotes=$(_do_git_repo_get_remote_list "${proj_dir}" "${fake_repo}")

  # FIXME: This will not work with current git setup.
  # Might be able to run with gitlab plugin later.
  local remote
  for remote in ${remotes[@]}; do
    _do_git_repo_remote_fetch "${proj_dir}" "${fake_repo}" $remote || _do_assert_fail
    _do_git_repo_remote_sync "${proj_dir}" "${fake_repo}" $remote || _do_assert_fail
  done
}
