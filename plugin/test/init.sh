function _do_test() {
  bash $DO_HOME/plugin/test/run.sh $@
  return $?
}

function _do_test_plugin_init() {
  _do_alias "do-test" "_do_test"

  # Tests and print output
  _do_alias "do-test-verbose" "_do_test --verbose"
}
