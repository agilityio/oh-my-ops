_do_plugin "nx"

function test_start_cmd() {
  local s

  s=$(_do_nx_repo_cmd "UNIT-TEST" "fake-repo" "start::web-app")
  _do_assert_eq "nx serve web-app" "$s"
}

function test_watch_cmd() {
  local s

  s=$(_do_nx_repo_cmd "UNIT-TEST" "fake-repo" "watch::web-app")
  _do_assert_eq "nx build --watch web-app" "$s"
}

function test_dep_graph_cmd() {
  local s

  s=$(_do_nx_repo_cmd "UNIT-TEST" "fake-repo" "dep-graph::web-app")
  _do_assert_eq "nx dep-graph web-app" "$s"
}
