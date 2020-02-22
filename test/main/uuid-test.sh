
function test_uuid_rand() {
  local res

  # Makes sure that uuid can generate and return non empty result
  res=$(_do_uuid_rand) || _do_assert_fail
  [ -n "$res" ] || _do_assert_fail
}
