_do_plugin "proj"
_do_plugin "repo"

_do_log_level_debug "proj"
_do_log_level_debug "repo"

proj_dir="./proj"
fake_repo="do-test-gen"

function test_setup() {
  # Creates a new project
  mkdir -p "${proj_dir}"
  _do_proj_init "${proj_dir}"
}

# Generates a new repositories and make sure some common files
# are generated.
#
function test_do_repo_gen() {
  # Removes the fake repository and generate it again.
  rm -rfd "${proj_dir}/${fake_repo}"
  _do_repo_gen "${proj_dir}" "${fake_repo}"

  # Makes sure that the repository contains expected files
  local repo_dir="${proj_dir}/${fake_repo}"
  _do_dir_assert "${repo_dir}"

  _do_file_assert ${repo_dir}/README.md
  _do_file_assert ${repo_dir}/.do.sh
  _do_file_assert ${repo_dir}/.editorconfig
  _do_file_assert ${repo_dir}/.gitignore
  _do_file_assert ${repo_dir}/.gitattributes
}

# function test_do_repo_clone() {
#     cd $proj_dir

#     rm -rfd ${fake_repo}

#     _do_repo_clone ${fake_repo}

#     _do_dir_assert $proj_dir/${fake_repo}

#     rm -rfd ${fake_repo}
# }

function test_do_list_repo() {
  test_do_repo_gen

  for repo in $(_do_list_repo); do
    # Try to find it.
    if [ "${repo}" = "${fake_repo}" ]; then
      return 0
    fi
  done

  _do_assert_fail
}

function test_repo_dir_array() {
  test_do_repo_gen

  local dir="${proj_dir}/${fake_repo}/src"
  mkdir -p "${dir}/p1"
  touch "${dir}/p1/do1.txt"

  mkdir -p "${dir}/p2"
  touch "${dir}/p2/do2.txt"

  # Find all directories that contains 'nothing.txt'. There should be none of that.
  ! _do_repo_dir_array_exists "${fake_repo}" "t1" || _do_assert_fail
  _do_repo_dir_array_new "${proj_dir}" "${fake_repo}" "t1" "nothing.txt" || _do_assert_fail

  _do_repo_dir_array_exists "${fake_repo}" "t1" || _do_assert_fail
  _do_repo_dir_array_is_empty "${fake_repo}" "t1" || _do_assert_fail

  # Find all directories that contains '*.txt'. There should be two of that.
  ! _do_repo_dir_array_exists "${fake_repo}" "t2" || _do_assert_fail
  _do_repo_dir_array_new "${proj_dir}" "${fake_repo}" "t2" "*.txt" || _do_assert_fail

  _do_repo_dir_array_exists "${fake_repo}" "t2" || _do_assert_fail
  ! _do_repo_dir_array_is_empty "${fake_repo}" "t2" || _do_assert_fail
  _do_repo_dir_array_print "${fake_repo}" "t2" || _do_assert_fail
}
