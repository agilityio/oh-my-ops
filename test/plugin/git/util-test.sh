_do_plugin 'git'

fake_repo="fake-repo"


function make_empty_fake_repo() {
    # Makes an empty fake git repository
    rm -rfd "${fake_repo}"
    mkdir -p "${fake_repo}"
    _do_dir_push "${fake_repo}"
    git init .

    # Makes two sub dirs in it.
    mkdir src 
    mkdir src/another

    _do_dir_pop
}

function assert_get_root_ok() {
    local repo_root="$(_do_git_util_get_root)" 
    _do_dir_assert "${repo_root}/.git"
}


# Makes sure that cannot get root from a non-git repository.
#
function test_get_util_get_root_not_found() {
    # Makes a directory that is not a git repository.
    mkdir "not-exist"
    _do_dir_push "not-exist"

    local repo_root
    repo_root=$(_do_git_util_get_root) || repo_root=""

    # The repo root should be empty
    _do_assert_eq "" "${repo_root}"
    
    _do_dir_pop
}


# Makes sure that get root works at the repo's root level 
# and also sub levels.
#
function test_git_util_get_root() {
    make_empty_fake_repo

    _do_dir_push "${fake_repo}"

    # Gets root level should be ok.
    assert_get_root_ok

    # Gets direct sub level should be ok.
    cd src 
    assert_get_root_ok

    # Gets deep sub level should be ok.
    cd another 
    assert_get_root_ok
    
    _do_dir_pop
}
