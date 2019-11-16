function test_set_new_and_destroy() {

  # Makes sure the set does not exist
  ! _do_set_exists "a" || _do_assert_fail

  # Creates a new set
  _do_set_new "a"
  _do_set_exists "a" || _do_assert_fail
  _do_set_new_if_not_exists "a" || _do_assert_fail

  # Makes sure the set is empty after creation
  _do_assert_eq "0" "$(_do_set_size "a")"

  _do_set_append "a" "1" "2" "3"
  _do_set_exists "a" || _do_assert_fail

  _do_set_print "a"

  _do_set_destroy "a"
  ! _do_set_exists "a" || _do_assert_fail
}

function test_set_append() {
  # Creates a new set
  _do_set_new "b"

  # Makes sure the set is empty after creation
  _do_assert_eq "0" "$(_do_set_size "b")"

  _do_set_append "b" "1" "2" "3"
  _do_assert_eq "3" "$(_do_set_size "b")"

  # Important to notes that duplicated keys are: 1,2 are ignored.
  _do_set_append "b" "A" '1' "B" '2' "C"
  _do_assert_eq "6" "$(_do_set_size "b")"

  _do_set_print "b"
  _do_set_contains "b" "A" || _do_assert_fail
  ! _do_set_contains "b" "Z" || _do_assert_fail

  _do_set_print "b"

  _do_set_destroy "b"
}

function test_set_clear() {
  # Creates a new set
  _do_set_new "b" "A" "B" "C"
  ! _do_set_is_empty "b" || _do_assert_fail
  _do_set_clear "b"
  _do_set_is_empty "b" || _do_assert_fail
}

function test_set_contains() {
  # Creates a new set
  _do_set_new "b" "A" "B" "C"
  _do_assert_eq "3" "$(_do_set_size "b")"

  _do_set_contains "b" "A" || _do_assert_fail
  ! _do_set_contains "b" "Z" || _do_assert_fail

  _do_set_print "b"

  _do_set_destroy "b"
}
