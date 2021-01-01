_do_plugin "jq"

function test_install() {
  _do_jq_util_install || _do_assert_fail
  _do_jq_util_exists || _do_assert_fail
  _do_jq_util_install_if_missing || _do_assert_fail
}
