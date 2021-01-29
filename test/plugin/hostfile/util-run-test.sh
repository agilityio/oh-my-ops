_do_plugin "hostfile"

function test_all() {
  _do_hostfile_util_remove_host 'fakehost'
  _do_hostfile_util_backup || _do_assert_fail

  ! _do_hostfile_util_host_exists 'fakehost' || _do_assert_fail

  _do_hostfile_util_create_host '127.100.200.1' 'fakehost' || _do_assert_fail
  _do_hostfile_util_host_exists 'fakehost' || _do_assert_fail

  _do_hostfile_util_create_host_if_missing '127.100.200.1' 'fakehost' || _do_assert_fail
  _do_hostfile_util_host_exists 'fakehost' || _do_assert_fail

  _do_hostfile_util_remove_host 'fakehost' || _do_assert_fail
  ! _do_hostfile_util_host_exists 'fakehost' || _do_assert_fail

  _do_hostfile_util_create_host_if_missing  '127.100.200.1' 'fakehost' || _do_assert_fail
  _do_hostfile_util_host_exists 'fakehost' || _do_assert_fail

  _do_hostfile_util_create_docker_host_if_missing || _do_assert_fail

  _do_hostfile_util_restore || _do_assert_fail
  ! _do_hostfile_util_host_exists 'fakehost' || _do_assert_fail
}
