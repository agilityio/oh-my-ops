function test_do_string_to_env_var() {
    _do_assert_eq "ABC" $(_do_string_to_env_var "ABC")
    _do_assert_eq "ABC" $(_do_string_to_env_var "abc")
    _do_assert_eq "A_B_C" $(_do_string_to_env_var "a.b/c")
}

function test_do_string_to_dash() {
   _do_assert_eq "ABC" $(_do_string_to_dash "ABC") 
   _do_assert_eq "AB-C" $(_do_string_to_dash "AB C") 
   _do_assert_eq "AB-C" $(_do_string_to_dash "AB.C") 
   _do_assert_eq "AB-C" $(_do_string_to_dash "AB/C") 
   _do_assert_eq "AB-C" $(_do_string_to_dash ".AB/C ") 
}