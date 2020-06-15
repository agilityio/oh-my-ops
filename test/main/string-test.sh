function test_do_string_to_upper() {
  _do_assert_eq "" $(_do_string_to_upper "")
  _do_assert_eq "ABC" "$(_do_string_to_upper "abc")"
  _do_assert_eq "AB.C" "$(_do_string_to_upper "aB.c")"
  _do_assert_eq "AB/C" "$(_do_string_to_upper "Ab/C")"
  _do_assert_eq ".AB/C " "$(_do_string_to_upper '.ab/C ')"
  _do_assert_eq "AB C" "$(_do_string_to_upper "ab C")"
}

function test_do_string_to_lower() {
  _do_assert_eq "" $(_do_string_to_lower "")
  _do_assert_eq "abc" "$(_do_string_to_lower "abc")"
  _do_assert_eq "ab.c" "$(_do_string_to_lower "aB.c")"
  _do_assert_eq "ab/c" "$(_do_string_to_lower "Ab/C")"
  _do_assert_eq ".ab/c " "$(_do_string_to_lower '.ab/C ')"
  _do_assert_eq "ab c" "$(_do_string_to_lower "ab C")"
}

function test_do_string_to_uppercase_var() {
  _do_assert_eq "" $(_do_string_to_uppercase_var "")
  _do_assert_eq "" $(_do_string_to_uppercase_var "  ")
  _do_assert_eq "ABC" $(_do_string_to_uppercase_var "ABC")
  _do_assert_eq "ABC" $(_do_string_to_uppercase_var "abc")
  _do_assert_eq "A_B_C" $(_do_string_to_uppercase_var "a.b/c")
  _do_assert_eq "A_B_C" $(_do_string_to_uppercase_var "a.b/ c")
  _do_assert_eq "A_B_C" $(_do_string_to_uppercase_var "  a.b/ c  ")
}

function test_do_string_to_dash() {
  _do_assert_eq "" $(_do_string_to_dash "")
  _do_assert_eq "" $(_do_string_to_dash "  ")
  _do_assert_eq "ABC" $(_do_string_to_dash "ABC")
  _do_assert_eq "AB-C" $(_do_string_to_dash "AB C")
  _do_assert_eq "AB-C" $(_do_string_to_dash "AB.C")
  _do_assert_eq "AB-C" $(_do_string_to_dash "AB/C")
  _do_assert_eq "AB-C" $(_do_string_to_dash ".AB/C ")
}

function test_do_string_to_lowercase_var() {
  _do_assert_eq "" $(_do_string_to_lowercase_var "")
  _do_assert_eq "" $(_do_string_to_lowercase_var "  ")
  _do_assert_eq "abc" $(_do_string_to_lowercase_var "ABC")
  _do_assert_eq "ab_c" $(_do_string_to_lowercase_var "AB C")
  _do_assert_eq "ab_c" $(_do_string_to_lowercase_var "AB.C")
  _do_assert_eq "ab_c" $(_do_string_to_lowercase_var "AB/C")
  _do_assert_eq "ab_c" $(_do_string_to_lowercase_var ".AB/C ")
  _do_assert_eq "ab_c" $(_do_string_to_lowercase_var ".AB/ C ")
  _do_assert_eq "ab_c" $(_do_string_to_lowercase_var ".AB/. C ")
}

function test_do_string_to_alias_name() {
  _do_assert_eq "" $(_do_string_to_alias_name "")
  _do_assert_eq "" $(_do_string_to_alias_name "  ")
  _do_assert_eq "abc" $(_do_string_to_alias_name "ABC")
  _do_assert_eq "ab-c" $(_do_string_to_alias_name "AB C")
  _do_assert_eq "ab-c" $(_do_string_to_alias_name "AB.C")
  _do_assert_eq "ab-c" $(_do_string_to_alias_name "AB/C")
  _do_assert_eq "ab-c" $(_do_string_to_alias_name ".AB/C ")

  # test remove src
  _do_assert_eq "ab-c" $(_do_string_to_alias_name ".AB/src/C ")
  _do_assert_eq "ab-c-d" $(_do_string_to_alias_name ".AB/src/C/bin/D ")
}

function test_do_string_contains() {
  _do_string_contains "ABC" "A" || _do_assert_fail
  _do_string_contains "ABC" "B" || _do_assert_fail
  _do_string_contains "ABC" "C" || _do_assert_fail
  _do_string_contains "ABC" "AB" || _do_assert_fail
  _do_string_contains "ABC" "BC" || _do_assert_fail
  _do_string_contains "ABC" "ABC" || _do_assert_fail
  ! _do_string_contains "ABC" "a" || _do_assert_fail
}

function test_do_string_startswith() {
  _do_string_startswith "ABC" "A" || _do_assert_fail
  _do_string_startswith "ABC" "AB" || _do_assert_fail
  _do_string_startswith "ABC" "ABC" || _do_assert_fail
  ! _do_string_startswith "ABC" "a" || _do_assert_fail
}

function test_do_string_endswith() {
  _do_string_endswith "ABC" "C" || _do_assert_fail
  _do_string_endswith "ABC" "BC" || _do_assert_fail
  _do_string_endswith "ABC" "ABC" || _do_assert_fail
  ! _do_string_endswith "ABC" "c" || _do_assert_fail
}
