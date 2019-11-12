source "$(_do_src_dir)/util.sh"


function test_setup() {
    # Removes the fake repository and generate it again.
    rm -rfd "${proj_dir}/${fake_repo}"
    _do_repo_gen "${proj_dir}" "${fake_repo}"
}


function test_do_git_repo_add_status_commit() {
    # Makes sure git repository is enabled
    _do_git_repo_enabled "${proj_dir}" "${fake_repo}" || _do_assert_fail

    # Display helps
    _do_git_repo_help "${proj_dir}" "${fake_repo}" || _do_assert_fail

    alias | grep do-fake-repo

    # Makes sure all git alias are available
    _do_alias_assert "do-fake-repo-git-status"
    _do_alias_assert "do-fake-repo-git-help"
    _do_alias_assert "do-fake-repo-git-commit"

    _do_alias_assert "do-all-git-status"
    _do_alias_assert "do-all-git-add"
    _do_alias_assert "do-all-git-status"

    # After generated , the files not yet been add. 
    # The repository should be cleaned.
    ! _do_git_repo_is_dirty "${proj_dir}" "${fake_repo}" || _do_assert_fail

    # Add the files to git, it should be dirty now.
    _do_git_repo_add "${proj_dir}" "${fake_repo}" || _do_assert_fail

    # Display git status should work.
    _do_git_repo_status "${proj_dir}" "${fake_repo}" || _do_assert_fail

    # Makes sure the git repository is dirty after adding the file
    _do_git_repo_is_dirty "${proj_dir}" "${fake_repo}" || _do_assert_fail

    # Makes sure the git repository is dirty after adding the file
    _do_git_repo_commit "${proj_dir}" "${fake_repo}" "sample message" || _do_assert_fail

    # After commit the repository should be clean again
    ! _do_git_repo_is_dirty "${proj_dir}" "${fake_repo}" || _do_assert_fail

    local remotes=$(_do_git_repo_get_remote_list "${proj_dir}" "${fake_repo}")
    local remote
    for remote in ${remotes[@]}; do 
        _do_git_repo_remote_fetch "${proj_dir}" "${fake_repo}" $remote || _do_assert_fail
    done
}


# Makes sure that the remote listing works.
#
function test_do_git_remote_list() {
    # Makes sure at least 1 remote found
    local repo=$(_do_proj_repo_get_default "${proj_dir}")

    local remotes=$(_do_git_get_default_remote_list "${proj_dir}")

    local size=${#remotes[@]}
    [ $size -gt 0 ] || _do_assert_fail

    # Makes sure we can get the list of remote uri for the generated repository
    for remote in ${remotes[@]}; do 
        local uri=$(_do_git_repo_get_remote_uri $proj_dir ${fake_repo} $remote)
        _do_assert "${uri}"
    done
}
