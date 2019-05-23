proj_dir=$(_do_proj_default_get_dir)
repo="test-gen"
repo_dir="${proj_dir}/${repo}"

function test_setup() {
    rm -rfd "${repo_dir}"
    # Generates the new npm repository
    _do_repo_gen ${repo}
    _do_dir_assert ${repo_dir}

    _do_npm_repo_gen "${proj_dir}" "${repo}" || _do_assert_fail
    _do_file_assert "${repo_dir}/package.json"
}

function test_teardown() {
    # Removes the newly generated npm repository
    rm -rfd "${repo_dir}"
}

function test_scan() {
    mkdir ${repo_dir}/proj1
    echo '{
  "name": "proj1",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "clean": "echo \"Error: no clean specified\" && exit 1"
  },
  "author": "",
  "license": "ISC"
}' > ${repo_dir}/proj1/package.json

    mkdir -p ${repo_dir}/src/proj2
    echo '{
  "name": "proj2",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "clean": "echo \"Error: no clean specified\" && exit 1"
  },
  "author": "",
  "license": "ISC"
}' > ${repo_dir}/src/proj2/package.json

    # Scans and found 3 npm sub projects
    local subprojs=( $(_do_npm_repo_scan "${proj_dir}" "${repo}") )
    _do_assert_eq "3" "${#subprojs[@]}"

    _do_npm_repo_uninit "${proj_dir}" "${repo}"
    _do_npm_repo_init "${proj_dir}" "${repo}"

    _do_npm_repo_help "${proj_dir}" "${repo}" || _do_assert_fail

    _do_npm_repo_build "${proj_dir}" "${repo}" || _do_assert_fail
    # _do_npm_repo_proj_cmd "${proj_dir}" "${repo}" "proj1" || _do_assert_fail
    # _do_npm_repo_proj_cmd "${proj_dir}" "${repo}" "src/proj2" || _do_assert_fail
}

function test_help() {
    _do_npm_repo_help "${proj_dir}" "${repo}" || _do_assert_fail
}

function test_clean() {
    _do_npm_repo_clean "${proj_dir}" "${repo}" || _do_assert_fail
    _do_npm_repo_clean "${proj_dir}" "${repo}" || _do_assert_fail
}

function test_build() {
    _do_npm_repo_build "${proj_dir}" "${repo}" || _do_assert_fail
}
