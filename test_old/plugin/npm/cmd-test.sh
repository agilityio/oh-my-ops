_do_plugin 'npm'
_do_log_level_debug 'npm'

function test_cmds() {
  local repo='fake-demo'
  mkdir -p "${repo}"

  echo '
{
  "name": "demo1",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo 'Do nothing'",
    "build": "echo 'Do nothing'",
    "clean": "echo 'Do nothing'",
    "start": "echo 'Do nothing'"
  },
  "author": "",
  "license": "ISC"
}
    ' >"${repo}/package.json"

  _do_npm_cmd "${repo}" 'install' || _do_assert_fail
  _do_npm_cmd "${repo}" 'test' || _do_assert_fail
  _do_npm_cmd "${repo}" 'build' || _do_assert_fail
  _do_npm_cmd "${repo}" 'clean' || _do_assert_fail
  _do_npm_cmd "${repo}" 'start' || _do_assert_fail
}
