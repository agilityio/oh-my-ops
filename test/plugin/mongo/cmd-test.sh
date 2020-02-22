_do_plugin "mongo"


function test_build_start_stop() {

  # Builds the mongo command
  _do_mongo_install || _do_assert_fail

  # The run it.
  _do_mongo_start || _do_assert_fail

  # Then should be ok to kill it
  _do_mongo_stop || _do_assert_fail
}

