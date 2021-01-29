_do_plugin "htpasswd"

function test_install() {
  _do_htpasswd_util_install || _do_assert_fail
  _do_htpasswd_util_exists || _do_assert_fail
  _do_htpasswd_util_install_if_missing || _do_assert_fail
}
