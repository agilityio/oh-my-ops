function test_do_repo_gen() {
    # Go to devops directory
    _do_dir_home_push
    pwd

    # Generates 
    local name="do-test-gen"
    rm -rfd ../$name

    _do_repo_gen $name

    _do_dir_assert "../$name"

    rm -rfd ../$name
}

function test_do_repo_clone() {
    # Go to devops directory
    _do_dir_home_push

    # Generates 
    local name="do-test-gen"
    rm -rfd ../$name

    _do_repo_clone $name

    _do_dir_assert "../$name"

    rm -rfd ../$name
}
