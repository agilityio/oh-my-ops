_do_plugin "proj"

proj_dir="./proj"
fake_repo="do-test-gen"

function test_setup() {
  # Creates a new project
  mkdir -p "${proj_dir}"
  _do_proj_init "${proj_dir}"
}

# Initializes a new project without any repository in it.
#
function test_init_with_no_default_repo() {
  _do_proj_init "${proj_dir}" || _do_assert_fail

  # Makes sure listing the project just fine.
  _do_proj_list || _do_assert_fail
}
