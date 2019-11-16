# Change the current directory to the specified directory and
# push it to the stack so that we can go back to it later.
#
# Arguments:
#   1. dir: The directory to go to.
#
function _do_dir_push() {
  local dir=${1?'dir arg required'}

  pushd "${dir}" &>/dev/null || _do_assert_fail
}

# Pops out the last working directory from the directory stack.
#
function _do_dir_pop() {
  popd &>/dev/null || _do_assert_fail
}

# Normalizes the given directory to an absolute one.
#
# Arguments:
#   1. dir: This is an actual directory that exists on disk.
#
function _do_dir_normalized() {
  local dir=${1?'dir arg required'}

  _do_dir_push "${dir}" || do_assert_fail

  echo $(pwd)

  _do_dir_pop
}

# Push the devops repository directory to directory stack.
#
function _do_dir_home_push() {
  _do_dir_push "${DO_HOME}" || _do_assert_fail
}

# Generates a random temp directory
#
function _do_dir_random_tmp_dir() {
  local tmp_dir="$(mktemp -d)"
  _do_assert "${tmp_dir}"
  echo "${tmp_dir}"
}

# Makes sure the specified directory argument actually exists.
#
# Arguments:
#   1. dir: The directory to check.
#
function _do_dir_assert() {
  local dir=${1?'dir arg required'}
  _do_assert "${dir}"

  [ -d "${dir}" ] || _do_assert_fail "Expected ${dir} a directory"
}

# Makes sure the specified directory argument does not exists.
#
# Arguments:
#   1. dir: The directory to check.
#
function _do_dir_assert_not() {
  local dir=${1?'dir arg required'}

  [ ! -d "${dir}" ] || _do_assert_fail "Expected ${dir} is not a directory"
}
