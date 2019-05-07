proj_dir=$(_do_proj_default_get_dir)
repo="test-gen"
repo_dir="${proj_dir}/${repo}"

function test_setup() {
    # Generates the new dotnet repository
    _do_repo_gen ${repo}
    _do_dir_assert ${repo_dir}

    _do_dotnet_repo_gen "${proj_dir}" "${repo}" || _do_assert_fail
    _do_file_assert "${repo_dir}/dotnet.sln"
}

function test_teardown() {
    # Removes the newly generated dotnet repository
    rm -rfd "${repo_dir}"
}

function test_help() {
    _do_dotnet_repo_help "${proj_dir}" "${repo}" || _do_assert_fail
}

function test_clean() {
    _do_dotnet_repo_clean "${proj_dir}" "${repo}" || _do_assert_fail
}

function test_build() {
    _do_dotnet_repo_build "${proj_dir}" "${repo}" || _do_assert_fail
}
