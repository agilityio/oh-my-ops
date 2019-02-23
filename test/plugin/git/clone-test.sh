proj_dir=$(_do_proj_default_get_dir)
fake_repo="do-test-gen"
repo_opts="$proj_dir $fake_repo"


function test_setup() {
    cd $proj_dir
    rm -rfd $fake_repo &> /dev/null

    _do_repo_clone $fake_repo

    _do_dir_assert $fake_repo

    # Makes sure git repository is enabled
    _do_git_repo_enabled $repo_opts || _do_assert_fail

    _do_repo_cd $repo_opts
}


function test_teardown() {
    cd $proj_dir
    rm -rfd $fake_repo
}


function test_clone() {

    # Display helps
    _do_git_repo_help $repo_opts || _do_assert_fail

    # After generated , the files not yet been add. 
    # The repository should be cleaned.
    ! _do_git_repo_is_dirty $repo_opts|| _do_assert_fail

    # Just modify a file.
    echo "Hello World" >> "$proj_dir/$fake_repo/README.md"

    # Add the files to git, it should be dirty now.
    _do_git_repo_add $repo_opts || _do_assert_fail

    # Display git status should work.
    _do_git_repo_status $repo_opts || _do_assert_fail

    # Makes sure the git repository is dirty after adding the file
    _do_git_repo_is_dirty $repo_opts || _do_assert_fail

    # Makes sure the git repository is dirty after adding the file
    _do_git_repo_commit $repo_opts "-m a sample message" || _do_assert_fail

    # After commit the repository should be clean again
    ! _do_git_repo_is_dirty $repo_opts|| _do_assert_fail

    local remotes=$(_do_git_repo_get_remote_list $repo_opts)
    local remote
    for remote in ${remotes[@]}; do 
        _do_git_repo_remote_fetch $repo_opts $remote || _do_assert_fail
        _do_git_repo_remote_sync $repo_opts $remote || _do_assert_fail
    done
}
