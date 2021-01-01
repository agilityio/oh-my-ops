_do_plugin "jq"

function test_get() {
  _do_assert_eq "world" "$(echo '{ "hello" : "world" }' | _do_jq_util_get 'hello')"
}

function test_array_length() {
  _do_assert_eq "0" "$(echo '[]' | _do_jq_util_array_length)"
  _do_assert_eq "1" "$(echo '[1]' | _do_jq_util_array_length)"
  _do_assert_eq "2" "$(echo '[1,2]' | _do_jq_util_array_length)"

  _do_assert_eq "0" "$(echo '{ "a": [] }' | _do_jq_util_array_length 'a')"
  _do_assert_eq "1" "$(echo '{ "a": [1] }' | _do_jq_util_array_length 'a')"
  _do_assert_eq "2" "$(echo '{ "a": [1,2] }' | _do_jq_util_array_length 'a')"
}
