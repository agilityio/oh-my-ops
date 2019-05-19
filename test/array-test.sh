function test_array_var_name() {
    # This is the internal array var name
    _do_assert_eq "__do_array_a" $(_do_array_var_name "a")
}

function test_array_new_and_destroy() {

    # Makes sure the array does not exist
    ! _do_array_exists "a" || _do_assert_fail

    # Creates a new array
    _do_array_new "a"
    _do_array_exists "a" || _do_assert_fail

    # Makes sure the array is empty after creation
    _do_assert_eq "0" $(_do_array_size "a")

    _do_array_append "a" "1" "2" "3"
    _do_array_exists "a" || _do_assert_fail

    _do_array_destroy "a"
    ! _do_array_exists "a" || _do_assert_fail    
}


function test_array_append() {
    # Creates a new array
    _do_array_new "b"

    # Makes sure the array is empty after creation
    _do_assert_eq "0" $(_do_array_size "b")

    _do_array_append "b" "1" "2" "3"
    _do_assert_eq "3" $(_do_array_size "b")

    _do_array_append "b" "A" "B" "C"
    _do_assert_eq "6" $(_do_array_size "b")

    _do_array_contains "b" "A" || _do_assert_fail
    ! _do_array_contains "b" "Z" || _do_assert_fail

    _do_array_destroy "b"
}


function test_array_contains() {
    # Creates a new array
    _do_array_new "b" "A" "B" "C"
    _do_assert_eq "3" $(_do_array_size "b")

    _do_array_contains "b" "A" || _do_assert_fail
    ! _do_array_contains "b" "Z" || _do_assert_fail

    _do_array_destroy "b"
}