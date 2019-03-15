function test_stack() {

    # The stack should not be defined by now.
    ! _do_stack_exists x || _do_assert_fail

    # Creates a new stack
    _do_stack_new x 
    _do_stack_exists x || _do_assert_fail

    # Push element to the stack
    _do_stack_push x "A1"
    _do_stack_push x "A2"

    # Prints out the stack
    _do_stack_print x

    # Makes sure stack has 2 elements
    _do_stack_size x size
    _do_assert_eq "2" "$size"

    # Pops out the stack elements
    _do_stack_pop x a
    _do_assert_eq "A2" "$a"
    _do_stack_pop x a
    _do_assert_eq "A1" "$a"

    # No elements remain
    _do_stack_size x size
    _do_assert_eq "0" "$size"

    # Just print out again
    _do_stack_print x

    # Destroy and the stack variable should be gone.
    _do_stack_destroy x 
    ! _do_stack_exists x || _do_assert_fail
}
