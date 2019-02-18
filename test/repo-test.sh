function test_do_repo_gen() {
    # Go to devops directory
    _do_dir_home_push
    pwd

    # Generates 
    local name="do-test-gen"
    rm -rfd ../$name

    _do_repo_gen $name

    _do_assert_dir "../$name"

    rm -rfd ../$name
}
