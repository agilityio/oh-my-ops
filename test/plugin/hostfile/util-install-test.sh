_do_plugin "hostfile"

function test_install() {
  _do_hostfile_util_install || _do_assert_fail
  _do_hostfile_util_exists || _do_assert_fail
  _do_hostfile_util_install_if_missing || _do_assert_fail
}
