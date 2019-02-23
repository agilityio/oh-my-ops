proj_dir=$(_do_dir_normalized $DO_HOME/..)
_do_proj_init "$proj_dir" "devops"

fake_repo="do-test-gen"
repo_opts="$proj_dir $fake_repo"


function test_setup() {
    # Go to devops directory
    cd $proj_dir

    # Generates 
    rm -rfd $fake_repo &> /dev/null

    _do_repo_gen $fake_repo
    _do_dir_assert "$proj_dir/$fake_repo"

    _do_repo_cd $repo_opts
}

function test_teardown() {
    cd $proj_dir
    rm -rfd $fake_repo
}


function test_do_git_repo_add_status_commit() {
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
    _do_git_repo_commit $repo_opts "-m a sample message" || _do_assert_fail

    # After commit the repository should be clean again
    ! _do_git_repo_is_dirty $repo_opts|| _do_assert_fail

    local remotes=$(_do_git_repo_get_remote_list $repo_opts)
    local remote
    for remote in ${remotes[@]}; do 
        _do_git_repo_remote_fetch $repo_opts $remote || _do_assert_fail
    done
}


# Makes sure that the remote listing works.
#
function test_do_git_remote_list() {
    # Makes sure at least 1 remote found
    local remotes=$(_do_git_get_default_remote_list)
    local size=${#remotes[@]}
    [ $size -gt 0 ] || _do_assert_fail

    # Makes sure we can get the list of remote uri for the generated repository
    for remote in ${remotes[@]}; do 
        local uri=$(_do_git_repo_get_remote_uri $proj_dir ${fake_repo} $remote)

        echo "$remote: $uri"
        _do_assert $uri
    done
}

