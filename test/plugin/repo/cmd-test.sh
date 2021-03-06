_do_plugin 'repo'

dir='fake/someone/lime'

function test_setup() {
  mkdir -p "${dir}/proj1/src/package1"
  mkdir -p "${dir}/proj1/src/abc"

  # Adds the root project
  _do_repo_dir_add "${dir}" || _do_assert_fail

  # Adds a sub project
  _do_repo_dir_add "${dir}/proj1" || _do_assert_fail

  # Adds a package to the project
  _do_repo_dir_add "${dir}/proj1/src/package1" || _do_assert_fail
}

function test_do_repo_plugin_exists() {
  _do_repo_plugin_cmd_add 'lime' 'repo' 'help' 'build'
  _do_repo_plugin_exists 'lime' 'repo' || _do_assert_fail
  ! _do_repo_plugin_exists 'lime' 'notexist' || _do_assert_fail
}

function test_do_repo_plugin_cmd_exists() {
  _do_repo_plugin_cmd_add 'lime' 'repo' 'help' 'build'
  _do_repo_plugin_cmd_exists 'lime' 'repo' 'help' || _do_assert_fail
  _do_repo_plugin_cmd_exists 'lime' 'repo' 'build' || _do_assert_fail
  ! _do_repo_plugin_cmd_exists 'lime' 'repo' 'notexist' || _do_assert_fail
}

function test_repo_plugin_cmd_add() {
  _do_repo_plugin_cmd_add 'lime' 'repo' 'help' 'build'

  # Adds more, with duplicated. The duplicated 'build' commands will not
  # be added.
  _do_repo_plugin_cmd_add 'lime' 'repo' 'init' 'clean' 'build'

  # Converts to array data structure to verify content
  _do_array_new 'cmds' $(_do_repo_plugin_cmd_list 'lime' 'repo')
  _do_array_print 'cmds'
  _do_assert_eq "4" "$(_do_array_size 'cmds')"

  _do_array_contains 'cmds' 'init' || _do_assert_fail
  _do_array_contains 'cmds' 'clean' || _do_assert_fail
  _do_array_contains 'cmds' 'help' || _do_assert_fail
  _do_array_contains 'cmds' 'build' || _do_assert_fail
}

# ==============================================================================
# Just fake repo command handlers.
# ==============================================================================

function do-repo-lime-help() {
  local dir=${1?'dir required'}
  local repo=${2?'repo required'}
  local cmd=${3?'cmd required'}

  echo "Fake help"
}

function _do_repo_repo_cmd_clean() {
  local dir=${1?'dir required'}
  local repo=${2?'repo required'}
  local cmd=${3?'cmd required'}

  echo "Fake clean"
}

function _do_repo_repo_cmd() {
  local dir=${1?'dir required'}
  local repo=${2?'repo required'}
  local cmd=${3?'cmd required'}

  echo "Fake build"
}
