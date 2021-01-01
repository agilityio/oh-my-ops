_do_plugin "htpasswd"

function test_install() {
  _do_htpasswd_util_install || _do_assert_fail
  _do_htpasswd_util_exists || _do_assert_fail
  _do_htpasswd_util_install_if_missing || _do_assert_fail
}

function test_run() {
  local line
  line=$(_do_htpasswd_util_run "user" "pass") || return 1
  _do_assert "${line}"
}
