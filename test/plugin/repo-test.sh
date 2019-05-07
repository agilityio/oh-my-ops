proj_dir=$(_do_proj_default_get_dir)
name="do-test-gen"

function test_do_repo_gen() {
    # Go to devops directory
    cd $proj_dir

    # Generates 
    rm -rfd $name

    _do_repo_gen $name

    _do_dir_assert $proj_dir/$name

    rm -rfd $name
}

function test_do_repo_clone() {
    cd $proj_dir

    rm -rfd $name

    _do_repo_clone $name

    _do_dir_assert $proj_dir/$name

    rm -rfd $name
}

function test_do_list_repo() {
    # generates a new repository
    test_do_repo_gen

    for repo in $(_do_list_repo); do 
        # Try to find it.
        if [ "${repo}" = "do-test-gen" ]; then 
            return 0
        fi 
    done 

    _do_assert_fail
}