function test_vlistmap_new_and_destroy() {

  # Makes sure the vlistmap does not exist
  ! _do_vlistmap_exists "a" || _do_assert_fail

  # Creates a new vlistmap
  _do_vlistmap_new "a"
  _do_vlistmap_exists "a" || _do_assert_fail
  _do_vlistmap_new_if_not_exists "a" || _do_assert_fail

  # Makes sure the vlistmap is empty after creation
  _do_assert_eq "0" "$(_do_vlistmap_size "a")"

  _do_vlistmap_value_append "a" "key" "1" "2" "3"
  _do_vlistmap_exists "a" || _do_assert_fail

  _do_vlistmap_print "a"

  _do_vlistmap_destroy "a"
  ! _do_vlistmap_exists "a" || _do_assert_fail
}

function test_vlistmap_append() {
  # Creates a new vlistmap
  _do_vlistmap_new "b"

  # Makes sure the vlistmap is empty after creation
  _do_assert_eq "0" "$(_do_vlistmap_size "b")"

  _do_vlistmap_value_append "b" "key" "1" "2" "3"
  _do_assert_eq "1" "$(_do_vlistmap_size "b")"

  _do_vlistmap_value_append "b" "key2" "A" "B" "C"
  _do_assert_eq "2" "$(_do_vlistmap_size "b")"

  _do_vlistmap_has_key "b" "key" || _do_assert_fail
  ! _do_vlistmap_has_key "b" "notexist" || _do_assert_fail

  _do_vlistmap_has_value "b" "key" "2" || _do_assert_fail
  _do_vlistmap_has_value "b" "key2" "C" || _do_assert_fail
  ! _do_vlistmap_has_value "b" "key" "notexist" || _do_assert_fail

  _do_vlistmap_print "b"

  _do_vlistmap_destroy "b"
}

function test_vlistmap_clear() {
  # Creates a new vlistmap
  _do_vlistmap_new "b"
  _do_vlistmap_value_append "b" "key" "A" "B" "C"

  ! _do_vlistmap_is_empty "b" || _do_assert_fail
  _do_vlistmap_clear "b"
  _do_vlistmap_is_empty "b" || _do_assert_fail
}

function test_vlistmap_get_set() {
  # Creates a new vlistmap
  _do_vlistmap_new "b"

  _do_vlistmap_set "b" "0" "a"
  _do_vlistmap_set "b" "1" "b"
  _do_vlistmap_set "b" "2" "c"

  local val
  val=$(_do_vlistmap_get "b" "0") || _do_assert_fail
  _do_assert_eq "a" "${val}"

  val=$(_do_vlistmap_get "b" "1") || _do_assert_fail
  _do_assert_eq "b" "${val}"

  val=$(_do_vlistmap_get "b" "2") || _do_assert_fail
  _do_assert_eq "c" "${val}"
}
