proj_dir=$(_do_dir_normalized $DO_HOME/..)
fake_repo="do-test-gen"
repo_opts="$proj_dir $fake_repo"


function test_setup() {
    echo "test_setup"
    # Go to devops directory
    _do_dir_home_push

    # Generates 
    rm -rfd ../$fake_repo

    _do_repo_gen $fake_repo
    _do_dir_assert "../$fake_repo"

}


function test_teardown() {
    _do_dir_home_push
    rm -rfd ../$fake_repo
}


function test_do_git_repo() {
    # Makes sure git repository is enabled
    _do_git_repo_enabled $repo_opts || _do_assert_fail

    # Display helps
    _do_git_repo_help $repo_opts || _do_assert_fail

    # After generated , the files not yet been add. 
    # The repository should be cleaned.
    ! _do_git_repo_is_dirty $repo_opts|| _do_assert_fail

    # Add the files to git, it should be dirty now.
    _do_git_repo_add $repo_opts || _do_assert_fail

    # Display git status should work.
    _do_git_repo_status $repo_opts || _do_assert_fail

    # Makes sure the git repository is dirty after adding the file
    _do_git_repo_is_dirty $repo_opts || _do_assert_fail

    # Makes sure the git repository is dirty after adding the file
    _do_git_repo_commit $repo_opts "-m \"a sample message\"" || _do_assert_fail
}
