_do_plugin "nx"

function test_start_cmd() {
  local s

  s=$(_do_nx_repo_cmd "UNIT-TEST" "fake-repo" "start::web-app")
  _do_assert_eq "nx serve web-app" "$s"
}
