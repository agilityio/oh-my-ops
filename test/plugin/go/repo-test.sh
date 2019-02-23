proj_dir=$(_do_proj_default_get_dir)
fake_repo="do-test-gen"
repo_opts="$proj_dir $fake_repo"


function test_setup() {
    cd $proj_dir

    # Generates 
    rm -rfd $fake_repo &> /dev/null

    _do_repo_gen $fake_repo
    _do_dir_assert $fake_repo

    _do_repo_cd $repo_opts
}


function test_teardown() {
    cd $proj_dir
    rm -rfd $fake_repo
}


function test_gen() {
    local package_dir="$proj_dir/$fake_repo/src/$fake_repo"
    _do_dir_assert "${package_dir}"
    _do_file_assert "${package_dir}/Gopkg.toml"
    _do_file_assert "${package_dir}/Gopkg.lock"

    _do_go_repo_enabled $repo_opts || _do_assert_fail
    _do_go_repo_dep_package_walk $repo_opts "echo package found: "
    _do_go_repo_dep_package_install $repo_opts $fake_repo
}


function test_do_go_repo_build() {
    _do_go_repo_build $repo_opts
}
