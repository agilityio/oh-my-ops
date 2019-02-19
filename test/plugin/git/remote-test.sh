
function test_do_git_remote_status() {
    _do_dir_home_push

    # Makes sure at least 1 remote found
    local remotes=$(_do_git_get_default_remote_list)
    local size=${#remotes[@]}
    [ $size -gt 0 ] || _do_assert_fail
}

    
# Makes sure function get remote uri work fine.
function test_do_git_repo_get_remote_uri() {
    for remote in $(_do_git_get_default_remote_list); do 
        local uri=$(_do_git_repo_get_remote_uri $DO_HOME $remote)
        echo "$remote: $uri"
        _do_assert $uri
    done
}

